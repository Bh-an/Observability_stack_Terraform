packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "grafana" {
  ami_name      = "${var.ami_prefix}-{{timestamp}}"
  instance_type = var.build_instance_type
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = "ec2-user"
  ssh_agent_auth = false

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  tags = {
    Name = "Grafana-HA-EFS-AMI"
  }
}

build {
  name    = "grafana-ami"
  sources = ["source.amazon-ebs.grafana"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      // Install Grafana from the provided RPM URL
      "sudo yum install -y ${var.grafana_rpm_url}",
      // CRITICAL: Install the EFS mount helper utilities
      "sudo yum install -y amazon-efs-utils",
      // Install the AWS SSM agent for debugging access
      "sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm",
      "sudo systemctl enable amazon-ssm-agent",
      "sudo systemctl start amazon-ssm-agent"
    ]
  }
}