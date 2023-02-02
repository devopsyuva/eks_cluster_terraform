variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "sudheer-demo"
}

variable "aws_region" {
  description = "Region on which to host EKS Cluster"
  type        = string
  default     = "us-east-1"
}

variable "vpc_network" {
  description = "VPC network CIDR for EKS cluster"
  type        = string
  default     = "192.168.0.0/16"
}

locals {
  public_subnets = {
    "${var.aws_region}a" = "192.168.0.0/18"
    "${var.aws_region}b" = "192.168.64.0/18"
  }
  private_subnets = {
    "${var.aws_region}a" = "192.168.128.0/18"
    "${var.aws_region}b" = "192.168.192.0/18"
  }
}

locals {
  node_policy_arn = {
    "node_policy" = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    "acr_policy"  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    "cni_policy"  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }
}

variable "cluster_arn" {
  description = "ARN of the policy to access EKS cluster"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

locals {
  common_tags = {
    Component   = "eks-cluster"
    Environment = "staging"
  }
}

variable "eks_node_ssh_key" {
  description = "Key pair to SSH nodes(compute nodes) of EKS cluster"
  type        = string
  default     = "awsdemokey"
}
