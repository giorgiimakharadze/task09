variable "project_base_name" {
  description = "Base name for all resources"
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the existing AKS subnet"
  type        = string
}

variable "firewall_subnet_address_prefix" {
  description = "Address prefix for the AzureFirewallSubnet (minimum /26)"
  type        = list(string)
}

variable "firewall_sku_tier" {
  description = "SKU tier for the Azure Firewall (Standard or Premium)"
  type        = string
}

variable "public_ip_sku" {
  description = "SKU for the public IP address"
  type        = string
}

variable "route_1_address_prefix" {
  description = "Address prefix for the first route"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Public IP address of the AKS load balancer (NGINX service)"
  type        = string
}

variable "app_rule_collection_name" {
  description = "Name of the application rule collection"
  type        = string
}

variable "net_rule_collection_name" {
  description = "Name of the network rule collection"
  type        = string
}

variable "nat_rule_collection_name" {
  description = "Name of the NAT rule collection"
  type        = string
}

variable "nsg_rule_priority" {
  description = "Priority of the NSG rule"
  type        = number
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "app_rule_http_name" {
  description = "Name of the HTTP application rule collection"
  type        = string
}

variable "app_rule_https_name" {
  description = "Name of the HTTPS application rule collection"
  type        = string
}
