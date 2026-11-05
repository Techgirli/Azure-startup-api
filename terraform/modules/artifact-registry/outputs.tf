output "repository_id" {
  value = artifact_registry_repository.this.repository_id
}

output "location" {
  value = artifact_registry_repository.this.location
}

output "repository_url" {
  value = "${artifact_registry_repository.this.location}-docker.pkg.dev/${var.project_id}/${artifact_registry_repository.this.repository_id}"
}   