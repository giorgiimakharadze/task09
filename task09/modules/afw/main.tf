resource "azurerm_subnet" "snet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.firewall_subnet_address_prefix
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = var.public_ip_sku
  tags                = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "afw" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  dns_proxy_enabled   = true
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ip-config"
    subnet_id            = azurerm_subnet.snet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_route_table" "rt" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  route {
    name                   = var.route_1_name
    address_prefix         = var.route_1_address_prefix
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  }

  route {
    name           = var.route_2_name
    address_prefix = "${azurerm_public_ip.pip.ip_address}/32"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "rtas" {
  subnet_id      = var.aks_subnet_id
  route_table_id = azurerm_route_table.rt.id
}

resource "azurerm_firewall_application_rule_collection" "firewall_app_rules" {
  for_each = { for rc in local.application_rules : rc.name => rc }

  name                = each.value.name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = "Allow"

  rule {
    name             = each.value.name
    source_addresses = each.value.source_addresses
    target_fqdns     = length(lookup(each.value, "target_fqdns", [])) > 0 ? each.value.target_fqdns : null
    fqdn_tags        = length(lookup(each.value, "fqdn_tags", [])) > 0 ? each.value.fqdn_tags : null

    dynamic "protocol" {
      for_each = length(lookup(each.value, "protocol", {})) > 0 ? [each.value.protocol] : []
      content {
        type = protocol.value.type
        port = protocol.value.port
      }
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "firewall_network_rules" {
  name                = var.net_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  dynamic "rule" {
    for_each = local.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = length(lookup(rule.value, "destination_fqdns", [])) > 0 ? [] : lookup(rule.value, "destination_addresses", [])
      destination_fqdns     = length(lookup(rule.value, "destination_fqdns", [])) > 0 ? lookup(rule.value, "destination_fqdns", []) : []
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "firewall_nat_rules" {
  name                = var.nat_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  dynamic "rule" {
    for_each = local.nat_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = [azurerm_public_ip.pip.ip_address]
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }
}
