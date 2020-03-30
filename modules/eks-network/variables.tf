variable "aws_az_number" {
  description = "How many AZs want to be used"
  type = string
  default = "3"
}

variable "cidr_block" {
  description = "The CIDR block for AWS VPC"
  type = string
}

variable "extra_tags" {
  description = "Extra AWS tags to be applied to created resources"
  type = map(string)
  default = {}
}

variable "name" {
  description = "vpc default name"
  type = string
}

variable "eks_cluster_name" {
  description = "the name of eks cluster"
  type = string
}