provider "aws" {
	default_tags {
	 tags = merge(var.tags, {
     owner       = "go"
		 se-region   = "apj"
		 purpose     = "hcp connectivity"
     ttl         = "-1"
		 terraform   = true
		 hc-internet-facing = false
   })
 }
}

locals {
  remote_vpc_id = "vpc-05d6b431311444675"
}

data aws_caller_identity "current" {}

data aws_availability_zones "this" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"


  name = "grant"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.this.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false
}

module "security_group_ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "ssh"
  description = "SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = concat(var.my_cidrs, var.public_subnets, var.private_subnets)
  ingress_rules = ["ssh-tcp"]
}

module "security_group_outbound" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "outbound"
  description = "outbound access"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]
}
