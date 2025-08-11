output "zone_id" {
  description = "The ID of the created private hosted zone."
  value       = aws_route53_zone.this.zone_id
}

output "zone_name" {
  description = "The name of the created private hosted zone."
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "A list of name servers for the zone."
  value       = aws_route53_zone.this.name_servers
}