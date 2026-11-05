variable "project_id" {
  type        = string
}

variable "network_name" {
  type        = string
  default     = "startup-vpc"
}

variable "subnetwork_name" {
  type        = string
  default     = "startup-subnet"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "ip_cidr_range" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "pods_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}

variable "services_cidr" {
  type        = string
  default     = "10.0.2.0/24"
}   