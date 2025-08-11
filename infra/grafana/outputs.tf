output "grafana_internal_dns_endpoint" {
  description = "The internal DNS endpoint for the Grafana service."
  value       = module.grafana_service.dns_record_fqdn
}

output "grafana_external_nlb_dns" {
  description = "The direct, public DNS name of the internet-facing Network Load Balancer for Grafana."
  value       = module.grafana_service.nlb_dns_name
}

output "grafana_efs_filesystem_id" {
  description = "The ID of the EFS filesystem used for Grafana's persistent storage."
  value       = module.grafana_efs.file_system_id
}