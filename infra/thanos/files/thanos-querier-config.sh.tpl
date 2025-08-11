#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# --- Variables (Populated by Terraform) ---
CONFIG_S3_URI="${config_s3_uri}"
PROMETHEUS_ENDPOINT="${prometheus_endpoint}"
STORE_GATEWAY_ENDPOINT="${store_gateway_endpoint}"

# --- Configuration Setup ---
echo "Fetching Thanos Querier service template from S3"
sudo aws s3 cp "$${CONFIG_S3_URI}" /tmp/thanos-querier.service

echo "Templating service file with endpoint DNS names"
sudo sed -i "s|__PROMETHEUS_LB_DNS_NAME__|$${PROMETHEUS_ENDPOINT}|g" /tmp/thanos-querier.service
sudo sed -i "s|__STORE_GATEWAY_LB_DNS_NAME__|$${STORE_GATEWAY_ENDPOINT}|g" /tmp/thanos-querier.service
sudo mv /tmp/thanos-querier.service /etc/systemd/system/thanos-querier.service

# --- Service Start ---
echo "Reloading systemd and starting Thanos Querier service"
sudo systemctl daemon-reload
sudo systemctl enable thanos-querier.service
sudo systemctl start thanos-querier.service

echo "User data script for Querier finished successfully!"