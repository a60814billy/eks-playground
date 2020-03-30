data "template_file" "worker_role_arns" {
  template = file("${path.module}/resources/work-node-arn.tpl")
  vars = {
    arn = aws_iam_role.eks-worker.arn
  }
}

data "template_file" "aws_auth_yml" {
  template = file("${path.module}/resources/aws-auth.yml.tpl")
  vars = {
    worker_role_arn = data.template_file.worker_role_arns.rendered
  }
}

resource "local_file" "aws_auth" {
  filename = local.aws_auth_yml_filepath
  content = data.template_file.aws_auth_yml.rendered
  file_permission = "0600"
}

resource "null_resource" "apply_aws_auth" {
  provisioner "local-exec" {
    working_dir = "${path.root}/.terraform/${var.name}"
    command = <<EOF
set +x; \
sleep 5; \
kubectl apply -f ./aws-auth.yml --kubeconfig ./kubeconfig;
EOF
    interpreter = [
      "/bin/bash",
      "-c"
    ]
  }

  triggers = {
    kubeconfig = data.template_file.kubeconfig.rendered
    aws_auth = data.template_file.aws_auth_yml.rendered
  }

  depends_on = [
    local_file.kubeconfig,
    local_file.aws_auth
  ]
}