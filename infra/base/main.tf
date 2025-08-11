# Configurations
provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, <5.0"
    }
  }

  cloud {
    organization = "Bh-an"

    workspaces {
      name = "Observability_Base"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "../../iac_modules/networking"

  region               = var.region
  environment          = var.environment
  platform             = var.platform
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "internal_zone" {
  source = "../../iac_modules/route53_private_zone"

  domain_name = "internal.${var.platform}.${var.environment}" 
  vpc_id      = module.networking.vpc_id
  environment = var.environment
  platform    = var.platform
}

module "shared_configs_bucket" {
  source = "../../iac_modules/s3_bucket"

  bucket_name = "${var.platform}-${var.environment}-shared-configs"
  
  platform    = var.platform
  environment = var.environment

  versioning_enabled = true
}