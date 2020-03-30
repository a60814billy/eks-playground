output "vpc" {
  value = aws_vpc.new_vpc.id
}

output "publicSubnets" {
  value = aws_subnet.public_subnet.*.id
}
