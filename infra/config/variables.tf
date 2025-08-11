variable "region" {
  description = "The AWS region for this deployment. Must match the 'base' workspace region."
  type        = string
  default     = "ap-south-1"
}

variable "platform" {
  description = "The platform this configuration belongs to."
  type        = string
  default     = "observability"
}

variable "environment" {
  description = "The environment for this configuration (e.g., dev, prod)."
  type        = string
  default     = "demo"
}