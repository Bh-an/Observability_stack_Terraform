output "prometheus_dns_endpoint" {
  description = "The fully qualified internal DNS name for the Prometheus service NLB."
  value       = module.prometheus_service.dns_record_fqdn
}

output "prometheus_nlb_dns" {
  description = "The direct, raw DNS name of the Network Load Balancer."
  value       = module.prometheus_service.nlb_dns_name
}

output "prometheus_security_group_id" {
  description = "The ID of the security group attached to the Prometheus instances. Useful for creating rules in other services."
  value       = module.prometheus_service.security_group_id
}

output "prometheus_iam_role_arn" {
  description = "The ARN of the IAM role assigned to the Prometheus instances."
  value       = module.prometheus_service.iam_role_arn
}

output "thanos_s3_bucket_id" {
  description = "The name (ID) of the S3 bucket created for the Thanos sidecar."
  value       = module.prometheus_thanos_bucket.bucket_id
}

output "thanos_s3_bucket_arn" {
  description = "The ARN of the S3 bucket created for the Thanos sidecar. This is used in IAM policies."
  value       = module.prometheus_thanos_bucket.bucket_arn
}