variable "instance_type" {
  type    = string
  default = "r5n.16xlarge"
}

variable "ebs_type"{
  type = string
  default = "gp3"
}

variable "ebs_iops"{
  type = number
  default = 10000
}


# AMI
data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

locals {
  common_tags = {
    project = "EBSVolume"
  }
}
