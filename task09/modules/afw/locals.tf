locals {
  firewall_public_ip = azurerm_public_ip.pip.ip_address

  network_rules = [
    {
      name                  = "AllowNTP"
      source_addresses      = ["*"]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      destination_fqdns     = []
      protocols             = ["UDP"]
    },
    {
      name                  = "apitcp"
      source_addresses      = ["*"]
      destination_ports     = ["9000"]
      destination_addresses = ["AzureCloud.eastus"]
      destination_fqdns     = []
      protocols             = ["TCP"]
    },
    {
      name                  = "apiudp"
      source_addresses      = ["*"]
      destination_ports     = ["1194"]
      destination_addresses = ["AzureCloud.eastus"]
      destination_fqdns     = []
      protocols             = ["UDP"]
    },
    {
      name                  = "allow-http-inbound"
      source_addresses      = ["*"]
      destination_ports     = ["80"]
      destination_addresses = ["*"]
      destination_fqdns     = []
      protocols             = ["TCP"]
    }
  ]

  application_rules = [
    {
      name             = "AllowContainerRegistry"
      source_addresses = ["*"]
      target_fqdns     = ["mcr.microsoft.com", "*.data.mcr.microsoft.com", "*.azurecr.io", "docker.io", "registry-1.docker.io", "production.cloudflare.docker.com"]
      fqdn_tags        = []
      protocol         = { port = 443, type = "Https" }
    },
    {
      name             = "AllowGoogleNginx"
      source_addresses = ["*"]
      target_fqdns     = ["www.google.com", "*.nginx.org"]
      fqdn_tags        = []
      protocol         = { port = 443, type = "Https" }
    },
    {
      name             = "aks-required"
      source_addresses = ["*"]
      fqdn_tags        = ["AzureKubernetesService"]
      target_fqdns     = []
      protocol         = {}
    },
    {
      name             = "allow-http"
      source_addresses = ["*"]
      fqdn_tags        = []
      target_fqdns     = ["*"]
      protocol         = { port = 80, type = "Http" }
    }
  ]

  nat_rules = var.aks_loadbalancer_ip != "" ? [
    {
      name               = "DNAT-NGINX"
      source_addresses   = ["*"]
      destination_ports  = ["80"]
      protocols          = ["TCP"]
      translated_address = var.aks_loadbalancer_ip
      translated_port    = "80"
    }
  ] : []
}
