variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the firewall resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
}

variable "firewall_subnet_address_prefix" {
  description = "Address prefix for the AzureFirewallSubnet (minimum /26)"
  type        = list(string)
}

variable "firewall_name" {
  description = "Name of the Azure Firewall"
  type        = string
}

variable "public_ip_sku" {
  type        = string
  description = "Public IP Sku"
}

variable "firewall_sku_tier" {
  description = "SKU tier for the Azure Firewall (Standard or Premium)"
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "Firewall SKU tier must be either 'Standard' or 'Premium'."
  }
}

variable "public_ip_name" {
  description = "Name of the public IP address for the firewall"
  type        = string
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet for route table association"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Public IP address of the AKS load balancer (NGINX service)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "route_1_name" {
  type        = string
  description = "Route 1 Name"
}

variable "route_1_address_prefix" {
  type        = string
  description = "Route 1 Address Prefix"
}

variable "route_2_name" {
  type        = string
  description = "Route 2 Name"
}
