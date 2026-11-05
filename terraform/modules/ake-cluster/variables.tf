variable "cluster_name" {
  type        = string
  description = "AKS cluster name"
}

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
  default     = "eastus"
}

variable "dns_prefix" {
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  type        = string
  default     = "1.30"
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
}

variable "node_pool_name" {
  type        = string
  default     = "systempool"
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_D2s_v5"
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

variable "workload_pool_name" {
  type        = string
  default     = "workloadpool"
}

variable "workload_vm_size" {
  type        = string
  default     = "Standard_D4s_v5"
}

variable "workload_node_count" {
  type        = number
  default     = 2
}

variable "workload_min_nodes" {
  type        = number
  default     = 2
}

variable "workload_max_nodes" {
  type        = number
  default     = 10
}

variable "pod_cidr" {
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "log_analytics_workspace_id" {
  type        = string
}

variable "private_cluster_enabled" {
  type        = bool
  default     = true
}

variable "environment" {
  type        = string
  description = "Environment label (staging/production)"
}   