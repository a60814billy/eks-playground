resource "aws_security_group" "worker" {
  name_prefix = "${var.name}-worker"
  description = "${var.name} EKS worker"

  vpc_id = data.aws_vpc.exist.id

  ingress {
    security_groups = [aws_security_group.eks.id]
    from_port = 0
    to_port = 0
    protocol = "tcp"
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(map(
  "Name", "${var.name}-eks-worker",
  ), var.extra_tags)
}