variable "kubeconfigPath" {
  description = "the kubeconfig file path"
  type = string
}

module "metrics-server" {
  source = "../k8s-apply-resources"
  kubeconfigPath = var.kubeconfigPath
  resourcePath = "${path.module}/resources"
}