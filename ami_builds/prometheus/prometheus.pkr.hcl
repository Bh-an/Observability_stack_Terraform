packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "prometheus" {
  ami_name      = "${var.ami_prefix}-{{timestamp}}"
  instance_type = var.build_instance_type
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = "ec2-user"
  ssh_agent_auth = false
  
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  tags = {
    Name = "Prometheus-HA-Thanos-Base-AMI"
    // Note: The IAM role is best attached in the Launch Template, not here.
  }
}

build {
  name    = "prometheus-ami"
  sources = ["source.amazon-ebs.prometheus"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y wget",

      // Install Prometheus
      "wget https://github.com/prometheus/prometheus/releases/download/v${var.prometheus_version}/prometheus-${var.prometheus_version}.linux-amd64.tar.gz",
      "tar xvfz prometheus-${var.prometheus_version}.linux-amd64.tar.gz",
      "sudo mv prometheus-${var.prometheus_version}.linux-amd64 /usr/local/prometheus",
      "sudo mv /usr/local/prometheus/prometheus /usr/local/bin/",
      "sudo mv /usr/local/prometheus/promtool /usr/local/bin/",

      // Install Thanos
      "wget https://github.com/thanos-io/thanos/releases/download/v${var.thanos_version}/thanos-${var.thanos_version}.linux-amd64.tar.gz",
      "tar xvfz thanos-${var.thanos_version}.linux-amd64.tar.gz",
      "sudo mv thanos-${var.thanos_version}.linux-amd64 /usr/local/thanos",
      "sudo mv /usr/local/thanos/thanos /usr/local/bin/",
      
      // Create users and data directories
      "sudo useradd --no-create-home --shell /bin/false prometheus",
      "sudo mkdir -p /var/lib/prometheus/data",
      "sudo chown -R prometheus:prometheus /usr/local/prometheus",
      "sudo chown -R prometheus:prometheus /var/lib/prometheus",

      // Install AWS SSM Agent
      "sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm",
      "sudo systemctl enable amazon-ssm-agent",
      "sudo systemctl start amazon-ssm-agent"
    ]
  }
}