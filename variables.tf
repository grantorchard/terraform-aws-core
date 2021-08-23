variable tags {
  type = map
  default = {}
}

variable public_subnets {
  type = list
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

variable private_subnets {
  type = list
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable vpc_cidr {
  type = string
  default = "10.0.0.0/16"
}

variable my_cidrs {
  type = list
}

variable sub_zone {
  type= list
  default = []
}