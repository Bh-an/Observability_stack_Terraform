locals {
  tags = {
    Service     = var.service_name
    Platform    = var.platform
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}