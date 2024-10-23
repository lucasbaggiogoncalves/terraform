module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.14.0"

  name = "${local.resource-prefix}-vpc-01"

  cidr = var.vpc_cidr

  azs             = var.avaliability_zones
  public_subnets  = var.subnets_cidr.private.public_subnets
  private_subnets = var.subnets_cidr.private.private_subnets
  intra_subnets   = var.subnets_cidr.private.intra_subnets

  public_subnet_names  = ["${local.resource-prefix}-subnet-public-1a", "${local.resource-prefix}-subnet-public-1b", "${local.resource-prefix}-subnet-public-1c"]
  private_subnet_names = ["${local.resource-prefix}-subnet-private-1a", "${local.resource-prefix}-subnet-private-1b", "${local.resource-prefix}-subnet-private-1c"]
  intra_subnet_names   = ["${local.resource-prefix}-subnet-intra-1a", "${local.resource-prefix}-subnet-intra-1b", "${local.resource-prefix}-subnet-intra-1c"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = var.tags
  nat_gateway_tags = {
    "Name" = "${local.resource-prefix}-vpc-01-nat-gateway-01"
  }
  igw_tags = {
    "Name" = "${local.resource-prefix}-vpc-01-igw-01"
  }
}