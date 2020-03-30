data "aws_ami" "eks_worker_ami" {
  most_recent = true

  owners = [
    "amazon"
  ]

  filter {
    name = "name"
    values = [
      "amazon-eks-node-${var.kubernetes_version}-*"
    ]
  }

  filter {
    name = "architecture"
    values = [
      "x86_64"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }
}