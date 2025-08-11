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
      name = "Observability_Grafana"
    }
  }
}

data "terraform_remote_state" "base" {
  backend = "remote"
  config = {
    organization = "Bh-an"
    workspaces = { name = "Observability_Base" }
  }
}

module "grafana_service" {
  source = "../../iac_modules/service"

  # General Config
  service_name = var.grafana_config.service_name
  platform     = var.platform
  environment  = var.environment
  region       = var.region

  # Networking
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  private_subnets = data.terraform_remote_state.base.outputs.private_subnet_ids
  # Use public subnets for an external-facing Load Balancer
  nlb_subnets     = data.terraform_remote_state.base.outputs.public_subnet_ids
  internal        = var.grafana_config.internal_lb

  # Instance & User Data
  image_id      = var.grafana_config.image_id
  instance_type = var.grafana_config.instance_type
  min_size                 = var.grafana_config.min_size
  max_size                 = var.grafana_config.max_size  
  desired_capacity         = var.grafana_config.desired_size
  user_data_script = templatefile("${path.module}/files/grafana-config.sh.tpl", {
  efs_file_system_id  = module.grafana_efs.file_system_id
  efs_access_point_id = module.grafana_efs.access_point_id
  aws_region          = var.region
  grafana_service_file_uri = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/grafana/grafana.service"
})

  # IAM
  policy_document = templatefile("${path.module}/files/grafana-policy.json.tpl", {
    config_bucket_arn = data.terraform_remote_state.base.outputs.shared_configs_bucket_arn,
    efs_arn           = module.grafana_efs.file_system_arn # Creates an implicit dependency
  })
  
  # Security & Ports
  ingress_rules = var.grafana_config.ingress_rules
  egress_rules  = var.grafana_config.egress_rules
  service_port  = var.grafana_config.service_port
  listener_port = var.grafana_config.listener_port

  # DNS
  hosted_zone_id  = data.terraform_remote_state.base.outputs.private_hosted_zone_id
  dns_record_name = "${var.grafana_config.service_name}.${data.terraform_remote_state.base.outputs.private_hosted_zone_name}"
}


module "grafana_efs" {
  source = "../../iac_modules/efs_storage"

  platform    = var.platform
  environment = var.environment
  vpc_id      = data.terraform_remote_state.base.outputs.vpc_id
  subnet_ids  = data.terraform_remote_state.base.outputs.private_subnet_ids

  efs_config = {
    name                  = var.efs_config.name
    access_point          = var.efs_config.access_point
    backup_policy_enabled = var.efs_config.backup_policy_enabled
    
    ingress_rules = [
      {
        description     = "Allow NFS access from the Grafana service"
        from_port       = 2049
        to_port         = 2049
        protocol        = "tcp"
        security_groups = [module.grafana_service.security_group_id]
      }
    ]
    egress_rules = [
      {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

