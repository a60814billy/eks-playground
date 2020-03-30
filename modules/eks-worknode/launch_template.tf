resource "aws_launch_template" "worker" {
  name_prefix = "${var.clusterName}-eks-worknode-"
  image_id = data.aws_ami.eks_worker_ami.id
  instance_type = "m5.large"

  key_name = var.workerKeyName

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    arn = var.workerIamProfileArn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = var.workerSecurityGroups
  }

  tag_specifications {
    resource_type = "instance"
    tags = var.extra_tags
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = var.extra_tags

  user_data = base64encode(data.template_file.userdata.rendered)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      image_id
    ]
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.clusterName
}

data "template_file" "userdata" {
  template = file("${path.module}/resources/update-eks.sh.tpl")
  vars = {
    clusterCertificate = data.aws_eks_cluster.cluster.certificate_authority.0.data
    clusterEndpoint = data.aws_eks_cluster.cluster.endpoint
    clusterName = data.aws_eks_cluster.cluster.name
    extraTag = var.extraKubeletArgs
  }
}