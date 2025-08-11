# --- General Configuration ---
variable "region" {
  description = "AWS region where resources will be deployed."
  type        = string
}

variable "platform" {
  description = "The name of the platform this service belongs to."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "service_name" {
  description = "The unique name of the service being deployed (e.g., grafana, prometheus)."
  type        = string
}

# --- Networking ---
variable "vpc_id" {
  description = "The ID of the VPC where the service will be deployed."
  type        = string
}

variable "private_subnets" {
  description = "A list of private subnet IDs for the Auto Scaling Group."
  type        = list(string)
}

variable "nlb_subnets" {
  description = "A list of subnet IDs for the Network Load Balancer (can be public or private)."
  type        = list(string)
}

# --- IAM ---
variable "policy_document" {
  description = "A JSON IAM policy document to attach to the service role. If null, no custom policy is created."
  type        = string
  default     = null
}

# --- ASG & Launch Template ---
variable "image_id" {
  description = "The Amazon Machine Image (AMI) ID for the instances."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type (e.g., t3.micro)."
  type        = string
}

variable "root_block_device_config" {
  description = "Configuration for the root block device of the instances. Allows overriding AMI defaults."
  type = object({
    volume_size = optional(number)
    volume_type = optional(string)
    delete_on_termination = optional(bool, true)
  })
  default = {}
}


variable "user_data_script" {
  description = "The user data script to run on instance startup. Will be base64 encoded."
  type        = string
  sensitive   = true
  default     = ""
}

variable "min_size" {
  description = "The minimum number of instances in the ASG."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of instances in the ASG."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "The desired number of instances to run."
  type        = number
  default     = 1
}

# --- Security Group ---
variable "ingress_rules" {
  description = "A list of ingress rules for the service's security group."
  type        = any
  default     = []
}

variable "egress_rules" {
  description = "A list of egress rules for the service's security group."
  type        = any
  default     = []
}

# --- Network Load Balancer ---
variable "internal" {
  description = "Set to true for an internal NLB, false for an internet-facing one."
  type        = bool
  default     = true
}

variable "service_port" {
  description = "The port on the instance that the target group will forward traffic to."
  type        = number
}

variable "listener_port" {
  description = "The port that the NLB will listen on."
  type        = number
}

variable "target_type" {
  description = "The target type for the target group (instance, ip, or lambda)."
  type        = string
  default     = "instance"
}

variable "health_check_config" {
  description = "A map of health check configurations for the target group."
  type        = map(any)
  default     = {}
}

# --- Optional DNS Record Configuration ---

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone where the DNS record will be created. If null, no record is created."
  type        = string
  default     = null
}

variable "dns_record_name" {
  description = "The desired FQDN for the service (e.g., grafana.internal.my-company.com). If null, no record is created."
  type        = string
  default     = null
}