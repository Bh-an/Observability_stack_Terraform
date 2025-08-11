# Observability_stack_Terraform
An observability stack for metrics and logs for workloads running in AWS created through only Terraform

## Current state:

I have written all the modules that will be used to deploy services. These are all modular and re-usable and are used with every service

The AMI are built with all required binaries pre-loaded so only the configuration is handled through user-data

Configs for every service are pulled from a shared S3 bucket

the base defines the whole networking for all services as well

The prometheus-thanos-grafana stack is done (prometheus + thanos sidecar / thanos querier / thanos gateway + grafana)

The elasticsearch and kibana stack only needs the main deployment modules to be written. 

Only grafana and kibanan run in public subnets, private subnes have a NAT gateway per AZ.

TBD:

Module for an event based config-reloaded (S3 events + SNS + Lambda)

Node ami with prometheus-exporter + Fluent-bit sidecar



