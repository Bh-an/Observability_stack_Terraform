variable "region" {
  description = "AWS region where all resources will be deployed."
  type        = string
}

variable "platform" {
  description = "The name of the platform this network belongs to (e.g., observability)."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "The root CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets. Must have one per AZ."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets. Must have one per AZ."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of Availability Zones to deploy subnets into (e.g., ['ap-south-1a', 'ap-south-1b'])."
  type        = list(string)
}