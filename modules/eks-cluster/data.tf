
locals {
  aws_auth_yml_filepath = "${path.root}/.terraform/${var.name}/aws-auth.yml"
  kubeconfig_filepath = "${path.root}/.terraform/${var.name}/kubeconfig"
}