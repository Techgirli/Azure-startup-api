resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  # Network
  default_node_pool {
    name       = var.node_pool_name
    vm_size    = var.node_vm_size
    node_count = var.node_count
    max_count  = var.max_nodes
    min_count  = var.min_nodes
    mode       = "System"
  }

  # Security
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  local_account_disabled    = true
  private_cluster_enabled   = var.private_cluster_enabled

  network_plugin   = "azure"
  network_policy   = "azure"
  network_profile {
    pod_cidr     = var.pod_cidr
    service_cidr = var.service_cidr
  }

  # Monitoring
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Autoscaling
  auto_scaler_profile {
    scale_down_unneeded_time = "10m"
    scale_down_utilization   = "0.5"
  }

  # Tags
  tags = {
    environment = var.environment
  }
}

# User node pool (for workloads)
resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                = var.workload_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size             = var.workload_vm_size
  node_count          = var.workload_node_count
  max_count           = var.workload_max_nodes
  min_count           = var.workload_min_nodes
  mode                = "User"
  os_disk_size_gb     = 128
  os_disk_type        = "PremiumSSD"

  tags = {
    environment = var.environment
  }
}   