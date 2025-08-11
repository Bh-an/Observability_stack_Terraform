resource "aws_launch_template" "this" {
  name_prefix   = "${var.service_name}-lt-"
  image_id      = var.image_id
  instance_type = var.instance_type

  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  vpc_security_group_ids = [aws_security_group.this.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.root_block_device_config.volume_size
      volume_type = var.root_block_device_config.volume_type
      
      delete_on_termination = var.root_block_device_config.delete_on_termination
    }
  }

  user_data = base64encode(var.user_data_script)

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}