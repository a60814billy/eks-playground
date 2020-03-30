resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = merge(map(
  "Name", "${var.name}-igw",
  "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
  ), var.extra_tags)
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.new_vpc.id

  tags = merge(map(
  "Name", "${var.name}-public",
  ), var.extra_tags)
}

resource "aws_main_route_table_association" "main_vpc_routes" {
  vpc_id = aws_vpc.new_vpc.id
  route_table_id = aws_route_table.default.id
}

resource "aws_route" "igw_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.default.id
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "route_net" {
  count = length(local.aws_azs)
  route_table_id = aws_route_table.default.id
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
}
