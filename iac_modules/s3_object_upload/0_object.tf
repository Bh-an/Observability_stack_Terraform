resource "aws_s3_object" "this" {
  bucket       = var.bucket_name
  key          = var.object_key
  source       = var.source_path
  content_type = var.content_type

  etag = filemd5(var.source_path)

  tags = merge(
    local.tags,
    var.additional_tags
  )
}