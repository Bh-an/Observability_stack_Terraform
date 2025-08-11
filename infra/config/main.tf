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
      name = "Observability_Configs"
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


module "upload_prometheus_config" {
  source = "../../iac_modules/s3_object_upload"

  bucket_name = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
  object_key  = "prometheus/prometheus.yaml.template"
  source_path = "${path.root}/configs/prometheus/prometheus.yaml.template"

  platform    = var.platform
  environment = var.environment

  additional_tags = {
    Service = "prometheus"
  }

  content_type = "text/plain"
}

module "upload_prometheus_service" {
  source = "../../iac_modules/s3_object_upload"

  bucket_name = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
  object_key  = "prometheus/prometheus.service"
  source_path = "${path.root}/configs/prometheus/prometheus.service"

  platform    = var.platform
  environment = var.environment

  additional_tags = {
    Service = "prometheus"
  }

  content_type = "text/plain"
}

module "upload_thanos_sidecar_service_template" {
  source = "../../iac_modules/s3_object_upload"

  bucket_name = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
  object_key  = "prometheus/thanos-sidecar.service.template"
  source_path = "${path.root}/configs/prometheus/thanos-sidecar.service.template"

  platform    = var.platform
  environment = var.environment

  additional_tags = {
    Service = "prometheus"
  }

  content_type = "text/plain"
}

module "upload_thanos_store_gateway_service" {
  source = "../../iac_modules/s3_object_upload"

  bucket_name = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
  object_key  = "thanos/thanos-store-gateway.service"
  source_path = "${path.root}/configs/thanos/thanos-store-gateway.service"

  platform    = var.platform
  environment = var.environment

  additional_tags = {
    Service = "thanos"
  }

  content_type = "text/plain"
}

module "upload_thanos_store_querier_service_template" {
  source = "../../iac_modules/s3_object_upload"

  bucket_name = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
  object_key  = "thanos/thanos-querier.service.template"
  source_path = "${path.root}/configs/thanos/thanos-querier.service.template"

  platform    = var.platform
  environment = var.environment

  additional_tags = {
    Service = "thanos"
  }

  content_type = "text/plain"
}

module "upload_grafana_service" {
  source = "../../iac_modules/s3_object_upload"

  bucket_name = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
  object_key  = "grafana/grafana.service"
  source_path = "${path.root}/configs/grafana/grafana.service"

  platform    = var.platform
  environment = var.environment

  additional_tags = {
    Service = "grafana"
  }

  content_type = "text/plain"
}