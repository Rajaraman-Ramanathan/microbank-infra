resource "aws_efs_file_system" "this" {
  creation_token = var.name
  encrypted  = true
  kms_key_id = var.kms_key_arn
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_security_group" "efs" {
  name        = "${var.name}-efs-sg"
  description = "EFS security group"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "nfs" {
  security_group_id = aws_security_group.efs.id
  from_port   = 2049
  to_port     = 2049
  ip_protocol = "tcp"
  cidr_ipv4 = var.private_subnet_cidr
  description = "Allow NFS from private subnets"
}

resource "aws_efs_mount_target" "this" {
  for_each = {
    for idx, subnet_id in var.private_subnet_ids :
    idx => subnet_id
  }

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "this" {
  count = var.create_access_point ? 1 : 0
  file_system_id = aws_efs_file_system.this.id
  posix_user {
    gid = var.posix_gid
    uid = var.posix_uid
  }
  root_directory {
    path = var.root_directory_path
    creation_info {
      owner_gid   = var.posix_gid
      owner_uid   = var.posix_uid
      permissions = "0755"
    }
  }

  tags = var.tags
}