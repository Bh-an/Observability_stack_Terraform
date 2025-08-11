resource "aws_iam_role" "this" {
  name = "${var.service_name}-${var.environment}-role"
  path = "/"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy" "this" {
  # This policy is only created if a policy document is provided.
  count = var.policy_document != null ? 1 : 0

  name        = "${var.service_name}-${var.environment}-policy"
  path        = "/"
  description = "Custom policy for the ${var.service_name} service."
  policy      = var.policy_document

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  # This attachment is only created if a policy document is provided.
  count = var.policy_document != null ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.service_name}-${var.environment}-instance-profile"
  role = aws_iam_role.this.name

  tags = local.tags
}