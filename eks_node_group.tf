resource "aws_eks_node_group" "webapplication" {
  cluster_name    = aws_eks_cluster.sg.name
  node_group_name = "web-application"
  remote_access {
    ec2_ssh_key = var.eks_node_ssh_key
  }
  node_role_arn = aws_iam_role.node_iam_role.arn
  subnet_ids    = flatten([aws_subnet.public_subnet.*.id, aws_subnet.private_subnet.*.id])

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [aws_iam_role_policy_attachment.node_policy]

  tags = merge(
    local.common_tags,
    {
      Name = "eks-node-group"
    }
  )
}

resource "aws_iam_role" "node_iam_role" {
  name               = "nodegrouprole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  count      = length(local.node_policy_arn)
  policy_arn = element(values(local.node_policy_arn), count.index)
  role       = aws_iam_role.node_iam_role.name
}
