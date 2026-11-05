variable "project_id" {
  type        = string
  description = "GCP project ID for staging"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "node_sa" {
  type        = string
  description = "Node service account email"
}   