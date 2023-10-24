# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "EKS-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = var.public_subnet_cidr
  private_subnets = var.private_subnet_cidr

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {

    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {

    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1
  }

  private_subnet_tags = {

    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal_elb"      = 1
  }
}

#Create EKS cluster using module
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  eks_managed_node_groups = {
    nodes = {

      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_type = ["t2.micro"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

