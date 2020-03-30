variable "kubernetes_version" {
  description = "the version of kubernetes cluster verions"
  type = string
  default = "1.14"
}

variable "clusterName" {
  description = "the name of EKS cluster"
  type = string
}

variable "workerIamProfileArn" {
  description = "the IAM Instance Profile arn for ec2 machine"
}

variable "workerKeyName" {
  description = "The key-pair of ec2 instance"
  type = string
  default = ""
}

variable "workerSecurityGroups" {
  description = "The security group for worker node"
  type = list(string)
  default = []
}

variable "extra_tags" {
  description = "Extra AWS tags to be applied to created resources"
  type = map(string)
  default = {}
}

variable "subnets" {
  description = "which subnet to place"
  type = list(string)
}

variable "worker_count" {
  description = "how many work node to be launch"
  type = number
  default = 1
}

variable "instanceType" {
  description = "instance type of work node"
  type = string
  default = "m4.large"
}

variable spot_max_price {
  type = string
  default = "0"
}

variable "extraKubeletArgs" {
  type = string
  default = ""
}

variable "schduleActionEnabled" {
  type = number
  default = 0
}
