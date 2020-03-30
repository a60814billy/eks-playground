output "eks-endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks-ca" {
  value = aws_eks_cluster.cluster.certificate_authority
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

output "update-kubeconfig-command" {
  value = <<EOF
Using the following command to update kubeconfig (you must using ${data.aws_caller_identity.current.arn} to authenticate)

aws --region ${data.aws_region.current.name} eks update-kubeconfig --name ${aws_eks_cluster.cluster.name}
EOF
}

output "worker-iam-profile-arn" {
  value = aws_iam_instance_profile.eks-worker.arn
}

output "worker-sg" {
  value = aws_security_group.worker.id
}

output "cluster-sg" {
  value = aws_security_group.eks.id
}
