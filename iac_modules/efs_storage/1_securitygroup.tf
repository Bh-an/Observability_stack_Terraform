# A dedicated security group for the EFS mount targets.
resource "aws_security_group" "efs" {
  name        = "${var.efs_config.name}-efs-sg"
  description = "Security group for the ${var.efs_config.name} EFS mount targets"
  vpc_id      = var.vpc_id

  # Dynamic ingress rules, configured from the variable
  dynamic "ingress" {
    for_each = var.efs_config.ingress_rules
    content {
      description     = lookup(ingress.value, "description", null)
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
    }
  }

  # Dynamic egress rules, configured from the variable
  dynamic "egress" {
    for_each = var.efs_config.egress_rules
    content {
      description = lookup(egress.value, "description", null)
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.efs_config.name}-efs-sg"
    }
  )
}