variable "aws_region" {
  type        = string
  description = "The AWS region where the AMI will be built and stored."
}

variable "source_ami" {
  type        = string
  description = "The ID of the source AMI (e.g., an Amazon Linux 2 AMI) to use for the build."
}

variable "build_instance_type" {
  type        = string
  description = "The EC2 instance type to use for the Packer build instance."
  default     = "t3.micro"
}

variable "ami_prefix" {
  type        = string
  description = "A prefix for the name of the final AMI."
}

variable "thanos_version" {
  type        = string
  description = "The version of Thanos to download and install."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to launch the build instance in."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet to launch the build instance in."
}