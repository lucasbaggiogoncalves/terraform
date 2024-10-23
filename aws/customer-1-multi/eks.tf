module "eks-01" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.26.0"

  ################################################################################
  # Configuração do cluster
  ################################################################################

  cluster_name    = "${local.resource-prefix}-eks-01"
  cluster_version = "1.31" # Fim do suporte standard (26/11/2025)

  iam_role_name            = "${local.resource-prefix}-iam-role-eks-01"
  iam_role_use_name_prefix = true

  cluster_security_group_name            = "${local.resource-prefix}-sg-eks-01-cluster"
  cluster_security_group_use_name_prefix = true

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = split(",", var.allowed_ips)
  cluster_endpoint_private_access      = true

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  control_plane_subnet_ids  = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2], module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  cluster_service_ipv4_cidr = var.eks_01_service_ip

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  tags = var.tags

  ################################################################################
  # Configuração dos nodes
  ################################################################################

  node_security_group_name            = "${local.resource-prefix}-sg-eks-01-nodegroup-01"
  node_security_group_use_name_prefix = true

  eks_managed_node_groups = {
    eks-01-nodegroup-01 = {

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]

      min_size       = 1
      max_size       = 2
      desired_size   = 1
      max_unvaliable = 1
    }
  }

  ################################################################################
  # Acesso ao cluster
  ################################################################################

  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = false

  access_entries = {
    name = {
      kubernetes_groups = []
      principal_arn     = var.iam_eks_access_entries.name

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}