resource "aws_efs_file_system" "this" {
  creation_token = var.efs_config.name
  encrypted      = true

  tags = merge(
    local.tags,
    {
      Name = var.efs_config.name
    },
    var.efs_config.additional_tags
  )
}

resource "aws_efs_mount_target" "mounts" {
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.shared_storage.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs_sg.id]
}