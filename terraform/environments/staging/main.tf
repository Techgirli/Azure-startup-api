module "aks" {
  source                  = "../../modules/aks-cluster"
  cluster_name            = "staging-aks"
  resource_group_name     = azurerm_resource_group.staging.name
  location                = var.location
  dns_prefix              = "staging-aks"
  sku_tier                = "Free"
  node_count              = 1
  min_nodes               = 1
  max_nodes               = 2
  node_vm_size            = "Standard_B1s"
  workload_node_count     = 1
  workload_min_nodes      = 1
  workload_max_nodes      = 2
  workload_vm_size        = "Standard_B1s"
  log_analytics_workspace_id = module.log_analytics.workspace_id
  private_cluster_enabled = false
  environment             = "staging"
}

module "acr" {
  source              = "../../modules/acr"
  registry_name       = "startupacrstg"
  resource_group_name = azurerm_resource_group.staging.name
  location            = var.location
  sku                 = "Basic"
  environment         = "staging"
}   