variable "app_name" {
  description = "app name"
  type        = string
  default     = null
}

variable "app_repo" {
  description = "app repo"
  type        = string
  default     = null
}

variable "registry" {
  description = "registry"
  type        = string
  default     = "795496658604.dkr.ecr.us-east-1.amazonaws.com"
}
