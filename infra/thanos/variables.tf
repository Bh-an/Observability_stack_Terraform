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

variable "store_gateway_config" {
  description = "Configuration for the Thanos Store Gateway service."
  type = object({
    image_id      = string
    instance_type = optional(string, "t3.medium")
    min_size      = optional(string, 1)
    max_size      = optional(string, 2)
    desired_size  = optional(string, 1)
    service_port  = optional(number, 10901) # gRPC port
    listener_port = optional(number, 10901)
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

variable "querier_config" {
  description = "Configuration for the Thanos Querier service."
  type = object({
    image_id      = string
    instance_type = optional(string, "t3.medium")
    min_size      = optional(string, 1)
    max_size      = optional(string, 3)
    desired_size  = optional(string, 2)
    service_port  = optional(number, 10902) # HTTP port
    listener_port = optional(number, 10902)
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