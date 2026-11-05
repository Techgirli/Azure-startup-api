terraform {
  backend "azurerm" {
    storage_account_name = "startupstatestg"
    container_name       = "tfstate"
    key                  = "staging.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "staging" {
  name     = "rg-startup-staging"
  location = var.location
  tags = {
    environment = "staging"
  }
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-startup-staging"
  resource_group_name = azurerm_resource_group.staging.name
  location            = var.location
  environment         = "staging"
}

module "log_analytics" {
  source               = "../../modules/log-analytics"
  workspace_name       = "log-startup-staging"
  resource_group_name  = azurerm_resource_group.staging.name
  location             = var.location
  environment          = "staging"
}

module "acr" {
  source              = "../../modules/acr"
  registry_name       = "startupacrstg"
  resource_group_name = azurerm_resource_group.staging.name
  location            = var.location
  sku                 = "Standard"
  environment         = "staging"
}

module "aks" {
  source                  = "../../modules/aks-cluster"
  cluster_name            = "staging-aks"
  resource_group_name     = azurerm_resource_group.staging.name
  location                = var.location
  dns_prefix              = "staging-aks"
  node_count              = 2
  min_nodes               = 1
  max_nodes               = 3
  node_vm_size            = "Standard_D2s_v5"
  workload_node_count     = 2
  workload_min_nodes      = 1
  workload_max_nodes      = 3
  workload_vm_size        = "Standard_D2s_v5"
  log_analytics_workspace_id = module.log_analytics.workspace_id
  private_cluster_enabled = false
  environment             = "staging"
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.resource_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].client_id
}   