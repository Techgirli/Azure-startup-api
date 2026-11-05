output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.primary.name
}

output "subnetwork_id" {
  value = google_compute_subnetwork.primary.id
}   