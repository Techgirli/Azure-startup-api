output "cluster_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config[0].raw
  sensitive = true
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "http_application_routing_enabled" {
  value = azurerm_kubernetes_cluster.this.http_application_routing_enabled
}   