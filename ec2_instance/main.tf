resource "aws_instance" "this" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  availability_zone    = var.availability_zone
  iam_instance_profile = module.attach_iam_role.iam_role_name
  subnet_id            = var.subnet_id

  tags = {
    Name = var.name
  }

}

# IAM Role
module "attach_iam_role" {
  source        = "./attach_iam_roles"
  iam_role_name = "${var.name}_Role"
}

resource "aws_volume_attachment" "this" {
  count       = length(aws_ebs_volume.this)
  device_name = local.device_ids[count.index]
  volume_id   = aws_ebs_volume.this.*.id[count.index]
  instance_id = aws_instance.this.id
}

resource "aws_ebs_volume" "this" {
  count             = var.num_ebs_volumes
  availability_zone = var.availability_zone
  size              = var.ebs_size
  type              = var.ebs_type
  iops              = var.ebs_iops
}