output "vpc_id" {
  description = "The ID of the main application VPC."
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC. Useful for security group rules."
  value       = module.networking.vpc_cidr_block
}

output "private_subnet_ids" {
  description = "A list of IDs for the private subnets, intended for application instances (ASGs)."
  value       = module.networking.private_subnet_ids
}

output "public_subnet_ids" {
  description = "A list of IDs for the public subnets, intended for public-facing resources like LBs or bastion hosts."
  value       = module.networking.public_subnet_ids
}




output "private_hosted_zone_id" {
  description = "The ID of the private Route 53 hosted zone."
  value       = module.internal_zone.zone_id
}

output "private_hosted_zone_name" {
  description = "The domain name of the private Route 53 hosted zone (e.g., internal.observability.demo)."
  value       = module.internal_zone.zone_name
}




output "shared_configs_bucket_id" {
  description = "The name (ID) of the S3 bucket for shared configurations."
  value       = module.shared_configs_bucket.bucket_id
}

output "shared_configs_bucket_arn" {
  description = "The ARN of the S3 bucket for shared configurations, used for IAM policies."
  value       = module.shared_configs_bucket.bucket_arn
}

output "shared_configs_bucket_regional_domain_name" {
  description = "The regional domain name of the shared configs S3 bucket."
  value       = module.shared_configs_bucket.bucket_regional_domain_name
}