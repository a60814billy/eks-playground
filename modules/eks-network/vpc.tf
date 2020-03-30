resource "aws_vpc" "new_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(map(
  "Name", var.name,
  "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
  ), var.extra_tags)
}

data "aws_availability_zones" "azs" {}

locals {
  aws_azs = slice(data.aws_availability_zones.azs.names, 0, var.aws_az_number)
}
