variable "node_vm_size" {
  type        = string
  default     = "Standard_B1s"   # ← was D2s_v5, now B1s (free tier)
}

variable "workload_vm_size" {
  type        = string
  default     = "Standard_B1s"   # ← was D4s_v5
}

variable "node_count" {
  type        = number
  default     = 1                # ← minimum
}

variable "min_nodes" {
  type        = number
  default     = 1
}

variable "max_nodes" {
  type        = number
  default     = 2                # ← keep low
}   