module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.0"

  name                = var.cluster_name
  kubernetes_version  = "1.33"
  
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 2

      instance_types = ["t3.small"]
    }
  }
  
}

resource "aws_ecr_repository" "eyego" {
  name                 = "eyego-app-img"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
