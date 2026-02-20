locals {
  firewall_public_ip = azurerm_public_ip.pip.ip_address

  nat_rules = [
    {
      name     = "aksfwnatr"
      priority = 100
      action   = "Dnat"
      rules = [
        {
          name               = "inboundrule"
          source_addresses   = ["*"]
          destination_ports  = ["80"]
          translated_address = var.aks_loadbalancer_ip
          translated_port    = "80"
          protocols          = ["Any"]
        }
      ]
    }
  ]

  network_rules = [
    {
      name     = "aksfwnr"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "apitcp"
          protocols             = ["TCP"]
          source_addresses      = ["*"]
          destination_addresses = ["AzureCloud.eastus"]
          destination_fqdns     = []
          destination_ports     = ["9000"]
        },
        {
          name                  = "apiudp"
          protocols             = ["UDP"]
          source_addresses      = ["*"]
          destination_addresses = ["AzureCloud.eastus"]
          destination_fqdns     = []
          destination_ports     = ["1194"]
        },
        {
          name                  = "time"
          protocols             = ["UDP"]
          source_addresses      = ["*"]
          destination_addresses = []
          destination_fqdns     = ["ntp.ubuntu.com"]
          destination_ports     = ["123"]
        },
        {
          name                  = "ghcr"
          protocols             = ["TCP"]
          source_addresses      = ["*"]
          destination_addresses = []
          destination_fqdns     = ["ghcr.io", "pkg-containers.githubusercontent.com"]
          destination_ports     = ["443"]
        },
        {
          name                  = "docker"
          protocols             = ["TCP"]
          source_addresses      = ["*"]
          destination_addresses = []
          destination_fqdns     = ["docker.io", "registry-1.docker.io", "production.cloudflare.docker.com"]
          destination_ports     = ["443"]
        },
        {
          name                  = "allow-http-inbound"
          protocols             = ["TCP"]
          source_addresses      = ["*"]
          destination_addresses = ["*"]
          destination_fqdns     = []
          destination_ports     = ["80"]
        }
      ]
    }
  ]

  application_rules = [
    {
      name     = "aksfwar"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name             = "aks-required"
          source_addresses = ["*"]
          fqdn_tags        = ["AzureKubernetesService"]
          target_fqdns     = []
          protocols        = []
        },
        {
          name             = "allow-http"
          source_addresses = ["*"]
          fqdn_tags        = []
          target_fqdns     = ["*"]
          protocols = [
            { type = "Http", port = 80 }
          ]
        }
      ]
    }
  ]
}
