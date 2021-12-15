resource "aws_iam_role" "eks_cluster" {
  name               = "ekscluster"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = merge(
    local.common_tags,
    {
      Name = "eks-sts"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = var.cluster_arn
  role       = aws_iam_role.eks_cluster.name
}
