#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# --- Variables (Populated by Terraform) ---
EFS_FILE_SYSTEM_ID="${efs_file_system_id}"
EFS_ACCESS_POINT_ID="${efs_access_point_id}"
AWS_REGION="${aws_region}"
# NEW: The full S3 URI for the Grafana service file.
GRAFANA_SERVICE_FILE_URI="${grafana_service_file_uri}"
GRAFANA_DATA_DIR="/var/lib/grafana"


# --- Prerequisite Installation ---
echo "Installing Grafana and EFS utilities"
# This assumes an Amazon Linux 2 environment.
# First, install the Grafana RPM. This creates the 'grafana' user and initial files.
sudo yum install -y https://dl.grafana.com/oss/release/grafana-9.5.3-1.x86_64.rpm
# Then, install the EFS mount helper.
sudo yum install -y amazon-efs-utils


# --- EFS Mount ---
echo "Mounting EFS filesystem $${EFS_FILE_SYSTEM_ID} via Access Point $${EFS_ACCESS_POINT_ID}"
sudo mkdir -p "$${GRAFANA_DATA_DIR}"
echo "$${EFS_FILE_SYSTEM_ID} $${GRAFANA_DATA_DIR} efs _netdev,tls,accesspoint=$${EFS_ACCESS_POINT_ID} 0 0" | sudo tee -a /etc/fstab
sudo mount -a

if ! sudo mount | grep -q "$${GRAFANA_DATA_DIR}"; then
  echo "FATAL: EFS mount failed for $${GRAFANA_DATA_DIR}" >&2
  exit 1
fi
echo "EFS successfully mounted to $${GRAFANA_DATA_DIR}"
sudo chown -R grafana:grafana "$${GRAFANA_DATA_DIR}"


# --- Systemd Service Configuration ---
echo "Fetching and installing custom Grafana service file from $${GRAFANA_SERVICE_FILE_URI}"
# This command will download the service file from S3 and overwrite the default one
# installed by the RPM package.
sudo aws s3 cp "$${GRAFANA_SERVICE_FILE_URI}" /etc/systemd/system/grafana-server.service


# --- Service Start ---
echo "Reloading systemd and starting Grafana service"
# We must run daemon-reload after modifying a service file.
sudo systemctl daemon-reload
sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server.service

echo "User data script for Grafana finished successfully!"