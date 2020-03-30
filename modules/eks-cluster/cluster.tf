resource "aws_cloudwatch_log_group" "eks_log" {
  name = "/aws/eks/${var.name}/cluster"
  retention_in_days = 7

  tags = var.extra_tags
}

resource "aws_eks_cluster" "cluster" {
  name = var.name
  role_arn = aws_iam_role.eks-cluster.arn
  version = var.cluster_version
  enabled_cluster_log_types = var.log_cluster

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_public_access = var.public_access
    endpoint_private_access = var.private_access

    security_group_ids = concat(var.cluster_sgs, [aws_security_group.eks.id])
  }

  tags = var.extra_tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
    aws_iam_role_policy_attachment.eks_service
  ]
}