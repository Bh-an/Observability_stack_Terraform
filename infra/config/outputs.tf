output "uploaded_config_files" {
  description = "A map detailing the configuration files uploaded to the shared S3 bucket."
  value = {
    # --- Prometheus Configs ---
    prometheus_config_template = {
      bucket   = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
      key      = module.upload_prometheus_config.object_id
      etag     = module.upload_prometheus_config.object_etag
      version  = module.upload_prometheus_config.object_version_id
      s3_uri   = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/${module.upload_prometheus_config.object_id}"
    }
    thanos_sidecar_service_template = {
      bucket   = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
      key      = module.upload_thanos_sidecar_service_template.object_id
      etag     = module.upload_thanos_sidecar_service_template.object_etag
      version  = module.upload_thanos_sidecar_service_template.object_version_id
      s3_uri   = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/${module.upload_thanos_sidecar_service_template.object_id}"
    }

    # --- Thanos Configs ---
    thanos_store_gateway_service = {
      bucket   = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
      key      = module.upload_thanos_store_gateway_service.object_id
      etag     = module.upload_thanos_store_gateway_service.object_etag
      version  = module.upload_thanos_store_gateway_service.object_version_id
      s3_uri   = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/${module.upload_thanos_store_gateway_service.object_id}"
    }
    thanos_querier_service_template = {
      bucket   = data.terraform_remote_state.base.outputs.shared_configs_bucket_id
      key      = module.upload_thanos_store_querier_service_template.object_id
      etag     = module.upload_thanos_store_querier_service_template.object_etag
      version  = module.upload_thanos_store_querier_service_template.object_version_id
      s3_uri   = "s3://${data.terraform_remote_state.base.outputs.shared_configs_bucket_id}/${module.upload_thanos_store_querier_service_template.object_id}"
    }
  }
}