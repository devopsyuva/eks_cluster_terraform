resource "aws_eks_cluster" "sg" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = flatten([aws_subnet.public_subnet.*.id, aws_subnet.private_subnet.*.id])
    // subnet_ids = ["${aws_subnet.public_subnet.*.id}", "${aws_subnet.private_subnet.*.id}"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]

  tags = merge(
    local.common_tags,
    {
      Name = "eks-cluster"
    }
  )
}
