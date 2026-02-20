project_base_name              = "cmtr-2lfxdvp4-mod9"
aks_subnet_name                = "aks-snet"
firewall_subnet_address_prefix = ["10.0.1.0/26"]
firewall_sku_tier              = "Standard"
public_ip_sku                  = "Standard"
route_1_address_prefix         = "0.0.0.0/0"
aks_loadbalancer_ip            = "20.85.134.49"
app_rule_collection_name       = "aksfwar"
net_rule_collection_name       = "aksfwnr"
nat_rule_collection_name       = "aksfwnatr"
nsg_rule_priority              = 400

tags = {
  Creator = "Giorgi Makharadze"
}
