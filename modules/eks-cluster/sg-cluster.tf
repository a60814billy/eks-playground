data "aws_subnet" "exist" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "exist" {
  id = data.aws_subnet.exist.vpc_id
}

resource "aws_security_group" "eks" {
  name_prefix = "${var.name}-eks-cluster-api-server-"
  description = "apply to eks cluster, is a sg for kubernetes cluster core components (api-server, ...)"

  vpc_id = data.aws_vpc.exist.id

  tags = merge(map(
  "Name", "${var.name}-eks-cluster",
  "kubernetes.io/cluster/${var.name}", "owned"
  ), var.extra_tags)

  ingress {
    description = "the kubernetes api-server 443 port"
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = var.allow_public_access_cidrs
  }

  ingress {
    description = "allow all internal traffic"
    protocol = "-1"
    from_port = 0
    to_port = 0
    self = true
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
