locals {
  firewall_public_ip = azurerm_public_ip.pip.ip_address

  network_rules = [
    {
      name                  = "apitcp"
      source_addresses      = ["*"]
      destination_ports     = ["9000"]
      destination_addresses = ["AzureCloud.${var.location}"]
      protocols             = ["TCP"]
    },
    {
      name                  = "apiudp"
      source_addresses      = ["*"]
      destination_ports     = ["1194"]
      destination_addresses = ["AzureCloud.${var.location}"]
      protocols             = ["UDP"]
    },
    {
      name              = "time"
      source_addresses  = ["*"]
      destination_ports = ["123"]
      destination_fqdns = ["ntp.ubuntu.com"]
      protocols         = ["UDP"]
    },
    {
      name              = "ghcr"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      destination_fqdns = [
        "ghcr.io",
        "pkg-containers.githubusercontent.com"
      ]
      protocols = ["TCP"]
    },
    {
      name              = "docker"
      source_addresses  = ["*"]
      destination_ports = ["443"]
      destination_fqdns = [
        "docker.io",
        "registry-1.docker.io",
        "production.cloudflare.docker.com"
      ]
      protocols = ["TCP"]
    }
  ]

  application_rules = [
    {
      name             = "fqdn-http"
      source_addresses = ["*"]
      target_fqdns     = ["*.azmk8s.io"]

      protocol = {
        type = "Http"
        port = 80
      }
    },
    {
      name             = "fqdn-https"
      source_addresses = ["*"]
      target_fqdns     = ["*.azmk8s.io"]

      protocol = {
        type = "Https"
        port = 443
      }
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
