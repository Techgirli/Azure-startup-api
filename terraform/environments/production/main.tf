terraform {
  backend "azurerm" {
    storage_account_name = "startupstateprd"
    container_name       = "tfstate"
    key                  = "production.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "prod" {
  name     = "rg-startup-prod"
  location = var.location
  tags = {
    environment = "production"
  }
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-startup-prod"
  resource_group_name = azurerm_resource_group.prod.name
  location            = var.location
  environment         = "production"
}

module "log_analytics" {
  source               = "../../modules/log-analytics"
  workspace_name       = "log-startup-prod"
  resource_group_name  = azurerm_resource_group.prod.name
  location             = var.location
  environment          = "production"
}

module "acr" {
  source              = "../../modules/acr"
  registry_name       = "startupacrprd"
  resource_group_name = azurerm_resource_group.prod.name
  location            = var.location
  sku                 = "Premium"
  environment         = "production"
}

module "aks" {
  source                  = "../../modules/aks-cluster"
  cluster_name            = "prod-aks"
  resource_group_name     = azurerm_resource_group.prod.name
  location                = var.location
  dns_prefix              = "prod-aks"
  node_count              = 3
  min_nodes               = 2
  max_nodes               = 10
  node_vm_size            = "Standard_D4s_v5"
  workload_node_count     = 3
  workload_min_nodes      = 2
  workload_max_nodes      = 10
  workload_vm_size        = "Standard_D4s_v5"
  log_analytics_workspace_id = module.log_analytics.workspace_id
  private_cluster_enabled = true
  environment             = "production"
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.resource_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].client_id
}   