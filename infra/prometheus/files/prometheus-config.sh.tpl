#!/bin/bash
set -euxo pipefail

# Log all output to a file for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# --- Variables (Populated by Terraform) ---
CONFIG_S3_URI="${config_s3_uri}"
STORAGE_S3_BUCKET="${storage_s3_bucket}"
AWS_REGION="${aws_region}"

# --- Dynamic Configuration ---
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PROMETHEUS_REPLICA_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# --- Configuration Setup ---
echo "Creating Prometheus configuration directory"
sudo mkdir -p /etc/prometheus
sudo chown prometheus:prometheus /etc/prometheus

echo "Fetching configuration templates from S3 URI: $${CONFIG_S3_URI}"
# Download all three required files
sudo aws s3 cp "$${CONFIG_S3_URI}/prometheus/prometheus.yaml.template" /tmp/prometheus.yml.template
sudo aws s3 cp "$${CONFIG_S3_URI}/prometheus/prometheus.service" /tmp/prometheus.service
sudo aws s3 cp "$${CONFIG_S3_URI}/prometheus/thanos-sidecar.service.template" /tmp/thanos-sidecar.service.template

echo "Templating Prometheus config with replica ID: $${PROMETHEUS_REPLICA_ID}"
sudo sed -i "s/__PROMETHEUS_REPLICA_ID__/$${PROMETHEUS_REPLICA_ID}/g" /tmp/prometheus.yml.template
sudo mv /tmp/prometheus.yml.template /etc/prometheus/prometheus.yml

echo "Templating Thanos Sidecar service file"
sudo sed -i "s|__S3_BUCKET_NAME__|$${STORAGE_S3_BUCKET}|g" /tmp/thanos-sidecar.service.template
sudo sed -i "s/__AWS_REGION__/$${AWS_REGION}/g" /tmp/thanos-sidecar.service.template

echo "Moving service files into place"
sudo mv /tmp/prometheus.service /etc/systemd/system/prometheus.service
sudo mv /tmp/thanos-sidecar.service.template /etc/systemd/system/thanos-sidecar.service

# --- Service Start ---
echo "Reloading systemd and starting services"
sudo systemctl daemon-reload

# Enable both services to start on boot
sudo systemctl enable prometheus.service
sudo systemctl enable thanos-sidecar.service

# Start both services (systemd will respect the 'After=' dependency)
sudo systemctl start prometheus.service
sudo systemctl start thanos-sidecar.service

echo "User data script finished successfully!"