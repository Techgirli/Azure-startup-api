variable "vnet_name" {
  type        = string
  default     = "startup-vnet"
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  default     = "eastus"
}

variable "address_space" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_subnet_name" {
  type        = string
  default     = "snet-aks"
}

variable "aks_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_name" {
  type        = string
  default     = "snet-app"
}

variable "app_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
}

variable "environment" {
  type        = string
  default     = "shared"
}   