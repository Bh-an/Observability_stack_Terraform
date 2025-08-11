output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer."
  value       = aws_lb.this.dns_name
}

output "nlb_zone_id" {
  description = "The Route 53 hosted zone ID for the Network Load Balancer."
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "The ARN of the NLB Target Group."
  value       = aws_lb_target_group.this.arn
}

output "security_group_id" {
  description = "The ID of the service's security group."
  value       = aws_security_group.this.id
}

output "iam_role_arn" {
  description = "The ARN of the IAM role created for the service."
  value       = aws_iam_role.this.arn
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.name
}

output "dns_record_fqdn" {
  description = "The fully qualified domain name of the created DNS record."
  value       = try(aws_route53_record.this[0].fqdn, null)
}