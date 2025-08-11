resource "aws_lb" "this" {
  name               = "${var.service_name}-nlb"
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.nlb_subnets

  enable_deletion_protection = false

  tags = local.tags
}

resource "aws_lb_target_group" "this" {
  name        = "${var.service_name}-tg"
  port        = var.service_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled  = lookup(var.health_check_config, "enabled", true)
    port     = lookup(var.health_check_config, "port", "traffic-port")
    protocol = lookup(var.health_check_config, "protocol", "TCP")
    interval = lookup(var.health_check_config, "interval", 30)
  }

  tags = local.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = local.tags
}