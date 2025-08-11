variable "platform" {
  description = "The name of the platform this object relates to."
  type        = string
}

variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to upload the object to."
  type        = string
}

variable "object_key" {
  description = "The key (path/filename) of the object inside the S3 bucket."
  type        = string
}

variable "source_path" {
  description = "The local path to the file that will be uploaded."
  type        = string
}

variable "content_type" {
  description = "The standard MIME type for the object."
  type        = string
  default     = "application/octet-stream" # A generic default for binary data
}

variable "additional_tags" {
  description = "A map of additional tags to apply to the S3 object."
  type        = map(string)
  default     = {}
}