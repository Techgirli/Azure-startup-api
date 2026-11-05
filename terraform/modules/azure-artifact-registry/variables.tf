variable "registry_name" {
  type        = string
  description = "ACR registry name (lowercase, no hyphens)"
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  default     = "eastus"
}

variable "sku" {
  type        = string
  default     = "Basic"
}

variable "environment" {
  type        = string
  default     = "shared"
}   