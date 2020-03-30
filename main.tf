locals {
  default_tag = map("Project", "eks-dev")
  eks_cluster_name = "eks-dev"
  k8s_version = "1.15"

  kubeconfig = "${path.root}/.terraform/${local.eks_cluster_name}/kubeconfig"
}

module "vpc" {
  source = "./modules/eks-network"
  name = "my-eks-test"
  eks_cluster_name = local.eks_cluster_name
  cidr_block = "10.73.0.0/16"
  aws_az_number = "2"
  extra_tags = merge(local.default_tag, map("Component", "vpc"))
}

module "cluster" {
  source = "./modules/eks-cluster"
  name = local.eks_cluster_name
  subnet_ids = module.vpc.publicSubnets
  extra_tags = merge(local.default_tag, map("Component", "cluster"))
  cluster_version = local.k8s_version
}

module "worker1" {
  source = "./modules/eks-worknode"
  clusterName = local.eks_cluster_name
  subnets = module.vpc.publicSubnets
  workerIamProfileArn = module.cluster.worker-iam-profile-arn
  kubernetes_version = local.k8s_version
  workerSecurityGroups = [
    module.cluster.worker-sg,
    module.cluster.cluster-sg
  ]
  extra_tags = merge(local.default_tag, map("Component", "worker"))
  worker_count = 3
  instanceType = "t3.medium"
}

module "metrics-server" {
  source = "./modules/k8s-metrics-server"
  kubeconfigPath = local.kubeconfig
}

module "k8s-dashboard" {
  source = "./modules/k8s-apply-resources"
  kubeconfigPath = local.kubeconfig
  resourcePath = "https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc7/aio/deploy/recommended.yaml"
}