variable "name" {}

variable "log_cluster" {
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "cluster_sgs" {
  description = "additional security group append to EKS cluster"
  type = list(string)
  default = []
}

variable cluster_version {
  description = "Kubernetes version (Ref. https://docs.aws.amazon.com/zh_tw/eks/latest/userguide/kubernetes-versions.html)"
  default = "1.14"
}

variable "subnet_ids" {
  description = "the subnets in your VPC where the worker nodes will run"
  type = list(string)
}

variable "extra_tags" {
  description = "Extra AWS tags to be applied to created resources"
  type = map(string)
  default = {}
}

variable "allow_public_access_cidrs" {
  description = "The cidr that allow public access"
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "public_access" {
  description = "Enable public API server endpoint access"
  type = bool
  default = true
}

variable "private_access" {
  description = "Enable private API server endpoint access"
  type = bool
  default = false
}