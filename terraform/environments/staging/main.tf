terraform {
  backend "gcs" {
    bucket = "my-startup-tfstate"
    prefix = "staging"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source = "../../modules/network"

  project_id      = var.project_id
  network_name    = "startup-vpc-staging"
  subnetwork_name = "startup-subnet-staging"
  region          = var.region
}

module "gke" {
  source = "../../modules/gke-cluster"

  project_id            = var.project_id
  cluster_name          = "staging-cluster"
  region                = var.region
  network_name          = module.network.network_name
  subnetwork_name       = module.network.subnetwork_name
  node_count            = 2
  min_nodes             = 1
  max_nodes             = 3
  node_machine_type     = "e2-medium"
  node_service_account  = var.node_sa
  environment           = "staging"
  deletion_protection   = false
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id  = var.project_id
  repo_name   = "my-repo"
  location    = "us"
  environment = "staging"
}   