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
      name = "Observability_Thanos"
    }
  }
}

# --- Data Sources: Read outputs from other workspaces ---
data "terraform_remote_state" "base" {
  backend = "remote"
  config = {
    organization = "Bh-an"
    workspaces = { name = "Observability_Base" }
  }
}

data "terraform_remote_state" "prometheus" {
  backend = "remote"
  config = {
    organization = "Bh-an"
    workspaces = { name = "Observability_Prometheus" }
  }
}


module "thanos_store_gateway" {
  source = "../../iac_modules/service"

  # General Config
  service_name = "thanos-store"
  platform     = var.platform
  environment  = var.environment
  region       = var.region

  # Networking
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  private_subnets = data.terraform_remote_state.base.outputs.private_subnet_ids
  nlb_subnets     = data.terraform_remote_state.base.outputs.private_subnet_ids

  # Instance & User Data
  image_id      = var.store_gateway_config.image_id
  instance_type = var.store_gateway_config.instance_type
  min_size                 = var.store_gateway_config.min_size
  max_size                 = var.store_gateway_config.max_size  
  desired_capacity         = var.store_gateway_config.desired_size
  user_data_script = templatefile("${path.module}/files/thanos-gateway-config.sh.tpl", {
    config_s3_uri     = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/thanos/thanos-store-gateway.service"
    storage_s3_bucket = data.terraform_remote_state.prometheus.outputs.thanos_s3_bucket_id
  })

  # IAM
  policy_document = templatefile("${path.module}/files/thanos-gateway-policy.json.tpl", {
    thanos_bucket_arn = data.terraform_remote_state.prometheus.outputs.thanos_s3_bucket_arn
    config_bucket_arn = data.terraform_remote_state.base.outputs.shared_configs_bucket_arn
  })
  
  # Security & Ports
  ingress_rules = var.store_gateway_config.ingress_rules
  egress_rules  = var.store_gateway_config.egress_rules
  service_port  = var.store_gateway_config.service_port
  listener_port = var.store_gateway_config.listener_port

  # DNS
  hosted_zone_id  = data.terraform_remote_state.base.outputs.private_hosted_zone_id
  dns_record_name = "thanos-store.${data.terraform_remote_state.base.outputs.private_hosted_zone_name}"
}


module "thanos_querier" {
  source = "../../iac_modules/service"

  # General Config
  service_name = "thanos-querier"
  platform     = var.platform
  environment  = var.environment
  region       = var.region

  # Networking
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  private_subnets = data.terraform_remote_state.base.outputs.private_subnet_ids
  nlb_subnets     = data.terraform_remote_state.base.outputs.private_subnet_ids

  # Instance & User Data
  image_id      = var.querier_config.image_id
  instance_type = var.querier_config.instance_type
  min_size                 = var.querier_config.min_size
  max_size                 = var.querier_config.max_size  
  desired_capacity         = var.querier_config.desired_size
  user_data_script = templatefile("${path.module}/files/thanos-querier-config.sh.tpl", {
    config_s3_uri          = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/thanos/thanos-querier.service.template"
    prometheus_endpoint    = data.terraform_remote_state.prometheus.outputs.prometheus_dns_endpoint
    store_gateway_endpoint = module.thanos_store_gateway.dns_record_fqdn
  })

  # IAM
  policy_document = templatefile("${path.module}/files/thanos-querier-policy.json.tpl", {
    config_bucket_arn = data.terraform_remote_state.base.outputs.shared_configs_bucket_arn
  })

  # Security & Ports
  ingress_rules = var.querier_config.ingress_rules
  egress_rules  = var.querier_config.egress_rules
  service_port  = var.querier_config.service_port
  listener_port = var.querier_config.listener_port

  # DNS
  hosted_zone_id  = data.terraform_remote_state.base.outputs.private_hosted_zone_id
  dns_record_name = "thanos-querier.${data.terraform_remote_state.base.outputs.private_hosted_zone_name}"
}