resource "aws_subnet" "public_subnet" {
  count = length(local.aws_azs)
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = cidrsubnet(aws_vpc.new_vpc.cidr_block, 4, count.index)
  availability_zone = local.aws_azs[count.index]

  map_public_ip_on_launch = true

  tags = merge(map(
  "Name", "${var.name}-public-${local.aws_azs[count.index]}",
  "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
  ), var.extra_tags)
}
