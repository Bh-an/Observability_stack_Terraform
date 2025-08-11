#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# --- Variables (Populated by Terraform) ---
CONFIG_S3_URI="${config_s3_uri}"
STORAGE_S3_BUCKET="${storage_s3_bucket}"

# --- Configuration Setup ---
sudo mkdir -p /var/lib/thanos-store

echo "Fetching Thanos Store Gateway service template from S3"
# Note: The object key is now part of the URI passed from Terraform
sudo aws s3 cp "$${CONFIG_S3_URI}" /tmp/thanos-store-gateway.service

echo "Templating service file with S3 bucket name"
sudo sed -i "s|__S3_BUCKET_NAME__|$${STORAGE_S3_BUCKET}|g" /tmp/thanos-store-gateway.service
sudo mv /tmp/thanos-store-gateway.service /etc/systemd/system/thanos-store-gateway.service

# --- Service Start ---
echo "Reloading systemd and starting Thanos Store Gateway service"
sudo systemctl daemon-reload
sudo systemctl enable thanos-store-gateway.service
sudo systemctl start thanos-store-gateway.service

echo "User data script for Store Gateway finished successfully!"