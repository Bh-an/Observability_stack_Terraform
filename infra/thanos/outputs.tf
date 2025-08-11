output "thanos_querier_dns_endpoint" {
  description = "The fully qualified internal DNS name for the Thanos Querier service."
  value       = module.thanos_querier.dns_record_fqdn
}

output "thanos_querier_nlb_dns" {
  description = "The direct, raw DNS name of the Network Load Balancer for the Querier."
  value       = module.thanos_querier.nlb_dns_name
}

output "thanos_querier_security_group_id" {
  description = "The ID of the security group attached to the Thanos Querier instances."
  value       = module.thanos_querier.security_group_id
}



output "thanos_store_gateway_dns_endpoint" {
  description = "The fully qualified internal DNS name for the Thanos Store Gateway service."
  value       = module.thanos_store_gateway.dns_record_fqdn
}

output "thanos_store_gateway_nlb_dns" {
  description = "The direct, raw DNS name of the Network Load Balancer for the Store Gateway."
  value       = module.thanos_store_gateway.nlb_dns_name
}

output "thanos_store_gateway_security_group_id" {
  description = "The ID of the security group attached to the Thanos Store Gateway instances."
  value       = module.thanos_store_gateway.security_group_id
}