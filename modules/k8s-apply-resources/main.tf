variable "kubeconfigPath" {
  description = "the kubeconfig file path"
  type = string
}

variable "resourcePath" {
  description = "the kubernetes resources directory or url"
  type = string
}

resource "null_resource" "apply-resource" {
  provisioner "local-exec" {
    working_dir = path.root
    command = <<EOF
set +x;
kubectl --kubeconfig "${var.kubeconfigPath}" apply -f "${var.resourcePath}";
EOF
    interpreter = [
      "/bin/bash",
      "-c"
    ]
  }
}