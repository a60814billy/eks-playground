data "template_file" "kubeconfig" {
  template = file("${path.module}/resources/kubeconfig.tpl")
  vars = {
    kubeconfig_name = var.name
    cluster_auth_base64 = aws_eks_cluster.cluster.certificate_authority.0.data
    endpoint = aws_eks_cluster.cluster.endpoint
    aws_authenticator_command = "aws"
    aws_authenticator_command_args = data.template_file.aws_authenticator_command_args.rendered
  }
}

data "template_file" "aws_authenticator_command_args" {
  template = <<EOF
        - --region
        - ${data.aws_region.current.name}
        - eks
        - get-token
        - --cluster-name
        - ${var.name}
EOF
}

resource "local_file" "kubeconfig" {
  filename = local.kubeconfig_filepath
  content = data.template_file.kubeconfig.rendered
  file_permission = "0600"
}