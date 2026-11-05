variable "project_id" {
  type        = string
}

variable "repo_name" {
  type        = string
  description = "Artifact Registry repository name"
}

variable "location" {
  type        = string
  default     = "us"
}

variable "environment" {
  type        = string
  default     = "shared"
}   