// prometheus/variables.pkr.hcl

variable "aws_region" {
  type        = string
  description = "The AWS region where the AMI will be created."
}

variable "source_ami" {
  type        = string
  description = "The source AMI ID for the build. Must exist in the specified AWS region."
}

variable "build_instance_type" {
  type        = string
  description = "The EC2 instance type to use for the build process."
  default     = "t3.micro"
}

variable "ami_prefix" {
  type        = string
  description = "The prefix for the final AMI name."
}

variable "prometheus_version" {
  type        = string
  description = "The version of Prometheus to install."
}

variable "thanos_version" {
  type        = string
  description = "The version of Thanos to install."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to launch the build instance in."
}

variable "subnet_id" {
  type        = string
  description = "The Subnet ID to launch the build instance in."
}