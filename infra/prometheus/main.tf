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
      name = "Observability_Prometheus"
    }
  }
}

data "terraform_remote_state" "base" {
  backend = "remote"
  config = {
    organization = "Bh-an"
    workspaces = {
      name = "Observability_Base"
    }
  }
}

module "prometheus_thanos_bucket" {
  source = "../../iac_modules/s3_bucket"

  bucket_name = coalesce(var.prometheus_config.thanos_bucket.bucket_name, "${var.platform}-${var.environment}-${var.prometheus_config.service_name}-thanos")
  platform    = var.platform
  environment = var.environment
  
  additional_tags = {
    Service = var.prometheus_config.service_name
  }

  versioning_enabled = true
  force_destroy      = var.prometheus_config.thanos_bucket.force_destroy
}

module "prometheus_service" {
  source = "../../iac_modules/service"

  # General Config
  service_name = var.prometheus_config.service_name
  platform     = var.platform
  environment  = var.environment
  region       = var.region

  # Networking
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  private_subnets = data.terraform_remote_state.base.outputs.private_subnet_ids
  nlb_subnets     = data.terraform_remote_state.base.outputs.private_subnet_ids

  # Instance & User Data
  image_id                 = var.prometheus_config.image_id
  instance_type            = var.prometheus_config.instance_type
  min_size                 = var.prometheus_config.min_size
  max_size                 = var.prometheus_config.max_size  
  desired_capacity         = var.prometheus_config.desired_size

  root_block_device_config = var.prometheus_config.root_block_device
  user_data_script         = templatefile("${path.module}/files/prometheus-config.sh.tpl", {
    config_s3_uri     = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}"
    storage_s3_bucket = module.prometheus_thanos_bucket.bucket_id
    aws_region        = var.region
  })

  health_check_config = var.prometheus_config.health_check_config

  # IAM
  policy_document = templatefile("${path.module}/files/prometheus-policy.json.tpl", {
    thanos_bucket_arn = module.prometheus_thanos_bucket.bucket_arn
    config_bucket_arn = data.terraform_remote_state.base.outputs.shared_configs_bucket_arn
  })
  
  # Security & Ports
  ingress_rules = var.prometheus_config.ingress_rules
  egress_rules  = var.prometheus_config.egress_rules
  service_port  = var.prometheus_config.service_port
  listener_port = var.prometheus_config.listener_port

  # DNS
  hosted_zone_id  = data.terraform_remote_state.base.outputs.private_hosted_zone_id
  dns_record_name = "${var.prometheus_config.service_name}.${data.terraform_remote_state.base.outputs.private_hosted_zone_name}"
}