variable "name" {
  type    = string
  default = "EBSTesting"
}
variable "ami_id" {}
variable "instance_type" {}
variable "availability_zone" {}
variable "subnet_id" {}

variable "num_ebs_volumes" {
  type    = number
  default = 5
}
variable "ebs_size" {
  type    = number
  default = 32
}
variable "ebs_type" {
  type    = string
  default = "gp3"
}
variable "ebs_iops" {
  type    = number
  default = 16000
}

locals {
  device_ids = [
    "/dev/sdf",
    "/dev/sdg",
    "/dev/sdh",
    "/dev/sdi",
    "/dev/sdj",
    "/dev/sdk",
    "/dev/sdl",
    "/dev/sdm",
    "/dev/sdn",
    "/dev/sdp",
  ]
}
