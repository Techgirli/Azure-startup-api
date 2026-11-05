output "cluster_endpoint" {
  value = module.gke.endpoint
}

output "artifact_registry_url" {
  value = module.artifact_registry.repository_url
}   