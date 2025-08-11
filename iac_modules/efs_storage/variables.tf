variable "platform" {
  description = "The name of the platform this storage belongs to."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EFS mount targets will be created."
  type        = string
}

variable "subnet_ids" {
  description = "A list of private subnet IDs where the EFS mount targets should be created."
  type        = list(string)
}

# --- The primary configuration object ---
variable "efs_config" {
  description = "A single object containing all configuration for the EFS file system."
  type = object({
    name = string # A unique name for the EFS file system (e.g., grafana-data)

    # Ingress/Egress for the EFS Security Group
    ingress_rules = list(object({
      description     = optional(string)
      from_port       = number
      to_port         = number
      protocol        = string
      security_groups = list(string) # EFS rules are typically based on SGs, not CIDRs
    }))
    egress_rules = list(object({
      description = optional(string)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))

    # Optional Access Point configuration
    access_point = optional(object({
      enabled = optional(bool, true)
      path    = optional(string, "/data")
    }), {})

    # Optional Backup Policy
    backup_policy_enabled = optional(bool, true)

    # Additional tags
    additional_tags = optional(map(string), {})
  })
}