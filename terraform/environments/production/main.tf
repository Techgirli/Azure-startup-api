terraform {
  backend "gcs" {
    bucket = "my-startup-tfstate"
    prefix = "production"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source = "../../modules/network"

  project_id      = var.project_id
  network_name    = "startup-vpc-prod"
  subnetwork_name = "startup-subnet-prod"
  region          = var.region
}

module "gke" {
  source = "../../modules/gke-cluster"

  project_id            = var.project_id
  cluster_name          = "prod-cluster"
  region                = var.region
  network_name          = module.network.network_name
  subnetwork_name       = module.network.subnetwork_name
  node_count            = 3
  min_nodes             = 2
  max_nodes             = 10
  node_machine_type     = "e2-standard-4"
  node_service_account  = var.node_sa
  environment           = "production"
  enable_binary_authorization = true
  deletion_protection   = true
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id  = var.project_id
  repo_name   = "my-repo"
  location    = "us"
  environment = "production"
}   