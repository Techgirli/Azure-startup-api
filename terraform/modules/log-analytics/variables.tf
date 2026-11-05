variable "workspace_name" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  default     = "eastus"
}

variable "environment" {
  type        = string
  default     = "shared"
}   