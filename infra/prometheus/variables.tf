# --- General Deployment Configuration ---
variable "region" {
  description = "The AWS region for this deployment. Should match the 'base' workspace region."
  type        = string
  default     = "ap-south-1"
}

variable "platform" {
  description = "The platform this service belongs to."
  type        = string
  default     = "observability"
}

variable "environment" {
  description = "The environment for this service deployment (e.g., dev, prod)."
  type        = string
  default     = "demo"
}

variable "prometheus_config" {
  description = "A single object containing all configuration for the Prometheus service deployment."
  type = object({
    service_name  = string
    image_id      = string
    instance_type = optional(string, "t3.medium")
    service_port  = optional(number, 9090)
    listener_port = optional(number, 9090)

    min_size      = optional(string, 1)
    max_size      = optional(string, 3)
    desired_size  = optional(string, 2)
    
    root_block_device = optional(object({
      volume_size = optional(number)
      volume_type = optional(string)
    }), { volume_size = 20, volume_type = "gp3" })
    
    thanos_bucket = optional(object({
      force_destroy = optional(bool, false)
      bucket_name   = optional(string, null)
    }), {})

    health_check_config = optional(map(any), {
      protocol = "HTTP"
      port     = "9090"
      path     = "/health"
      matcher  = "200"
    })

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