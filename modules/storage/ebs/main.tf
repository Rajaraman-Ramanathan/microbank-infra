resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.volume_type
  encrypted         = true
  kms_key_id        = var.kms_key_arn
  iops              = var.iops
  throughput        = var.throughput
  snapshot_id       = var.snapshot_id

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_volume_attachment" "this" {
  count = var.attach_volume ? 1 : 0
  device_name = var.device_name
  volume_id   = aws_ebs_volume.this.id
  instance_id = var.instance_id
  stop_instance_before_detaching = true
}