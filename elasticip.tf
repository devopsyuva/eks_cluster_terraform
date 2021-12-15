resource "aws_eip" "eks_eip" {
  vpc = true

  tags = merge(
    local.common_tags,
    {
      Name = "eks-eip"
    }
  )
}
