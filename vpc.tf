resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_network // "192.168.0.0/16"
  enable_dns_hostnames = "true"

  tags = merge(
    local.common_tags,
    {
      Name = "eks-network"
    }
  )
}
