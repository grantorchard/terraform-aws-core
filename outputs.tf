output vpc_id {
  value = module.vpc.vpc_id
}

output private_subnets {
  value = module.vpc.private_subnets
}

output public_subnets {
  value = module.vpc.public_subnets
}

output security_group_ssh {
  value = module.security_group_ssh.id
}

output security_group_outbound {
  value = module.security_group_outbound.id
}

output account_id {
  value = data.aws_caller_identity.current.account_id
}
