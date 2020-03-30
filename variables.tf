variable "region" {
  default = "us-east-1"
}

variable aws_access_key {
  type = string
}

variable aws_secret_key {
  type = string
}

variable "amis" {
  default = {
    "us-east-1": "ami-b374d5a5"
  }
}

variable "eks-cluster-name" {
  type = string
  default = "My-EKS"
}
