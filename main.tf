data aws_caller_identity "current" {}

data aws_availability_zones "this" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"


  name = "core"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.this.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = var.tags
}

module "security_group_ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.13.0"

  name        = "ssh"
  description = "SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [
    "${var.my_cidr}",
    "10.0.0.0/16"
  ]
  ingress_rules = ["ssh-tcp"]
  tags = var.tags
}

module "security_group_outbound" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.13.0"

  name        = "outbound"
  description = "outbound access"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]
  tags = var.tags
}

data "aws_route53_zone" "main" {
  name = "hashidemos.io"
}

# AWS SUBZONE

resource "aws_route53_zone" "aws_sub_zone" {
  for_each = toset(var.sub_zone)
  name    = each.value
  comment = "Managed by Terraform, Delegated Sub Zone for AWS for go.hashidemos.io"

  tags = {
    name       = "go"
    owner      = "Grant Orchard"
    created-by = "Grant Orchard"
    ttl        = "-1"
  }
}

resource "aws_route53_record" "aws_sub_zone_ns" {
  depends_on = [aws_route53_zone.aws_sub_zone]
  for_each = toset(var.sub_zone)
  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value
  type    = "NS"
  ttl     = "30"

  records = [
    for awsns in aws_route53_zone.aws_sub_zone[each.value].name_servers :
    awsns
  ]
}