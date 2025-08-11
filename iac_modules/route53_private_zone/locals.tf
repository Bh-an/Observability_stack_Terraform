locals {
  # Base tags applied to all resources in the module.
  tags = {
    Platform    = var.platform
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}