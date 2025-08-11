resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  # Merge the standard base tags with any extra tags provided by the user.
  tags = merge(
    local.tags,
    {
      Name = var.bucket_name
    },
    var.additional_tags
  )
}