variable "bucket_name" {
  description = "The globally unique name of the S3 bucket."
  type        = string
}

variable "platform" {
  description = "The name of the platform this bucket belongs to."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string
}

variable "additional_tags" {
  description = "A map of additional tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Set to true to enable versioning on the bucket."
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "If true, all public access to the bucket will be blocked. Highly recommended."
  type        = bool
  default     = true 
}

variable "encryption_configuration" {
  description = "A map defining the server-side encryption configuration. Set enabled=false to disable."
  type = object({
    enabled    = bool
    algorithm  = optional(string, "AES256")
    kms_key_id = optional(string, null)
  })
  default = {
    enabled    = true
    algorithm  = "AES256"
    kms_key_id = null
  }
}

variable "force_destroy" {
  description = "Set to true to allow deleting a non-empty bucket. Use with caution."
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "A list of lifecycle rule objects to apply to the bucket."
  type        = any
  default     = null
}