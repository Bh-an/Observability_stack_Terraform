output "file_system_id" {
  description = "The ID of the EFS file system."
  value       = aws_efs_file_system.this.id
}

output "file_system_arn" {
  description = "The ARN of the EFS file system."
  value       = aws_efs_file_system.this.arn
}

output "access_point_id" {
  description = "The ID of the EFS Access Point. This should be used for mounting if it exists."
  value       = try(aws_efs_access_point.this[0].id, null)
}

output "security_group_id" {
  description = "The ID of the security group created for the EFS mount targets."
  value       = aws_security_group.efs.id
}