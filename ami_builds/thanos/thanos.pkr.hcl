packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "thanos" {
  ami_name      = "${var.ami_prefix}-{{timestamp}}"
  instance_type = var.build_instance_type
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = "ec2-user"
  ssh_agent_auth = false
  
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  tags = {
    Name = "Thanos-Base-AMI"
  }
}

build {
  name    = "thanos-base"
  sources = ["source.amazon-ebs.thanos"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y wget",

      // Install Thanos
      "wget https://github.com/thanos-io/thanos/releases/download/v${var.thanos_version}/thanos-${var.thanos_version}.linux-amd64.tar.gz",
      "tar xvfz thanos-${var.thanos_version}.linux-amd64.tar.gz",
      "sudo mv thanos-${var.thanos_version}.linux-amd64/thanos /usr/local/bin/",
      
      // Install AWS SSM Agent
      "sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm",
      "sudo systemctl enable amazon-ssm-agent",
      "sudo systemctl start amazon-ssm-agent",

      // Cleanup
      "rm -rf thanos-${var.thanos_version}.linux-amd64.tar.gz thanos-${var.thanos_version}.linux-amd64"
    ]
  }
}