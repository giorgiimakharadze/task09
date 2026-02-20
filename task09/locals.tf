locals {
  resource_group_name = "${var.project_base_name}-rg"
  vnet_name           = "${var.project_base_name}-vnet"
  aks_cluster_name    = "${var.project_base_name}-aks"
  firewall_name       = "${var.project_base_name}-afw"
  public_ip_name      = "${var.project_base_name}-pip"
  route_table_name    = "${var.project_base_name}-rt"
  route_1_name        = "${var.project_base_name}-route-1"
  route_2_name        = "${var.project_base_name}-route-2"
}
