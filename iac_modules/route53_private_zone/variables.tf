variable "domain_name" {
  description = "The private domain name for the hosted zone (e.g., internal.my-company.com)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate the private hosted zone with."
  type        = string
}

variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "platform" {
  description = "The name of the platform."
  type        = string
}