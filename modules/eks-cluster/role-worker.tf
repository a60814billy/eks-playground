resource "aws_iam_role" "eks-worker" {
  name_prefix = "${var.name}-eks-worker-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.extra_tags
}

resource "aws_iam_instance_profile" "eks-worker" {
  name_prefix = "${var.name}-eks-worker-"
  role = aws_iam_role.eks-worker.id
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    principals {
      identifiers = [
        "ec2.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-worker.id
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-worker.id
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-worker.id
}