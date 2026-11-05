resource "artifact_registry_repository" "this" {
  location      = var.location
  repository_id = var.repo_name
  description   = "Docker image repository for ${var.repo_name}"
  format        = "DOCKER"

  labels = {
    environment = var.environment
  }
}   