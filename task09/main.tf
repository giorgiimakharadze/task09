data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_cluster_name
  resource_group_name = local.resource_group_name
}

data "azurerm_resources" "aks_nsg" {
  resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
  type                = "Microsoft.Network/networkSecurityGroups"
}

module "afw" {
  source = "./modules/afw"

  resource_group_name            = local.resource_group_name
  location                       = data.azurerm_resource_group.rg.location
  vnet_name                      = local.vnet_name
  firewall_subnet_address_prefix = var.firewall_subnet_address_prefix
  firewall_name                  = local.firewall_name
  firewall_sku_tier              = var.firewall_sku_tier
  public_ip_name                 = local.public_ip_name
  public_ip_sku                  = var.public_ip_sku
  route_table_name               = local.route_table_name
  route_1_name                   = local.route_1_name
  route_1_address_prefix         = var.route_1_address_prefix
  route_2_name                   = local.route_2_name
  aks_subnet_id                  = data.azurerm_subnet.aks_subnet.id
  aks_loadbalancer_ip            = var.aks_loadbalancer_ip
  tags                           = var.tags
}

resource "azurerm_network_security_rule" "allow_firewall_to_lb" {
  name                        = var.nsg_rule_name
  priority                    = var.nsg_rule_priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = module.afw.firewall_public_ip
  destination_address_prefix  = var.aks_loadbalancer_ip
  resource_group_name         = data.azurerm_kubernetes_cluster.aks.node_resource_group
  network_security_group_name = data.azurerm_resources.aks_nsg.resources[0].name
}
