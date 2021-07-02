module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ebs-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a"]
  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24"]

  enable_nat_gateway               = true
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support   = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = local.common_tags
}

module "ec2"{
  source = "./ec2_instance"
  ami_id = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  availability_zone = module.vpc.azs[0]
  subnet_id = module.vpc.private_subnets[0]
  ebs_type = "gp3"
  ebs_iops = 10000
}