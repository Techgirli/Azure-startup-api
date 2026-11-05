variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "cluster_name" {
  type        = string
  description = "GKE cluster name"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Cluster region"
}

variable "network_name" {
  type        = string
  description = "VPC network name"
}

variable "subnetwork_name" {
  type        = string
  description = "Subnetwork name"
}

variable "node_pool_name" {
  type        = string
  default     = "primary"
}

variable "node_count" {
  type        = number
  default     = 2
}

variable "min_nodes" {
  type        = number
  default     = 1
}

variable "max_nodes" {
  type        = number
  default     = 5
}

variable "node_machine_type" {
  type        = string
  default     = "e2-medium"
}

variable "node_service_account" {
  type        = string
  description = "Service account for GKE nodes"
}

variable "release_channel" {
  type        = string
  default     = "REGULAR"
}

variable "enable_binary_authorization" {
  type        = bool
  default     = false
}

variable "deletion_protection" {
  type        = bool
  default     = true
}

variable "environment" {
  type        = string
  description = "Environment label (staging/production)"
}   