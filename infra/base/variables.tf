variable "region" {
  description = "AWS cloud region"
  default     = "ap-south-1"
}

variable "platform" {
  description = "Associated Platform"
  default     = "observability"
}

variable "environment" {
  description = "Resource Environment"
  default     = "demo"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for Public Subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for Private Subnets."
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}