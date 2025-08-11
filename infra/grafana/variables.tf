variable "region" {
  description = "The AWS region for this deployment."
  type        = string
  default     = "ap-south-1"
}

variable "platform" {
  description = "The platform this service belongs to."
  type        = string
  default     = "observability"
}

variable "environment" {
  description = "The environment for this service deployment."
  type        = string
  default     = "demo"
}

variable "grafana_config" {
  description = "Configuration for the Grafana service."
  type = object({
    service_name  = string
    image_id      = string
    instance_type = optional(string, "t3.medium")
    min_size      = optional(string, 1)
    max_size      = optional(string, 2)
    desired_size  = optional(string, 1)
    
    service_port  = optional(number, 3000)
    listener_port = optional(number, 443) # Default to 443 for an external LB
    internal_lb   = optional(bool, false) # Default to an external (internet-facing) LB

    ingress_rules = list(object({
      description = optional(string)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      description = optional(string)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
}

# --- EFS Storage Configuration ---
variable "efs_config" {
  description = "Configuration for the EFS file system for Grafana."
  type = object({
    name = string
    access_point = optional(object({
      enabled = optional(bool, true)
      path    = optional(string, "/grafana")
    }), {})
    backup_policy_enabled = optional(bool, true)
  })
}