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
  default     = "t2.micro"
}

variable "ami_prefix" {
  type        = string
  description = "The prefix for the final AMI name."
}

variable "grafana_rpm_url" {
  type        = string
  description = "The full URL to the Grafana RPM to be installed."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to launch the build instance in."
}

variable "subnet_id" {
  type        = string
  description = "The Subnet ID to launch the build instance in."
}