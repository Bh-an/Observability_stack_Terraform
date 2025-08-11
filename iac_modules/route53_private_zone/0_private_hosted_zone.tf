resource "aws_route53_zone" "this" {
  name = var.domain_name

  # This vpc block is what makes the hosted zone private.
  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.platform}-${var.environment}-private-hosted-zone"
    }
  )
}