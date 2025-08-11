resource "aws_route53_record" "this" {
  count = var.hosted_zone_id != null && var.dns_record_name != null ? 1 : 0
  
  zone_id = var.hosted_zone_id
  name    = var.dns_record_name
  type    = "A"

  alias {
    name = aws_lb.this.dns_name
    zone_id = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}