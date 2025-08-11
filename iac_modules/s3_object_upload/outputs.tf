output "object_id" {
  description = "The object key."
  value       = aws_s3_object.this.id
}

output "object_etag" {
  description = "The ETag of the object, which is an MD5 hash of the content."
  value       = aws_s3_object.this.etag
}

output "object_version_id" {
  description = "The version ID of the object, if versioning is enabled on the bucket."
  value       = aws_s3_object.this.version_id
}