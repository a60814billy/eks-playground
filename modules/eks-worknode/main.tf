resource "aws_autoscaling_group" "workers" {
  name_prefix = "${var.clusterName}-eks-workers-asg"
  max_size = var.worker_count * 3
  min_size = var.worker_count
  desired_capacity = var.worker_count

  vpc_zone_identifier = var.subnets

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.worker.id
        version = "$Latest"
      }

      override {
        instance_type = var.instanceType
      }
    }

    instances_distribution {
      spot_max_price = var.spot_max_price == "0" ? "" : var.spot_max_price
      on_demand_percentage_above_base_capacity = var.spot_max_price == "0" ? 1 : 0
    }
  }

  tags = concat([
    {
      key = "kubernetes.io/cluster/${var.clusterName}"
      value = "owned"
      propagate_at_launch = true
    },
    {
      key = "Name"
      value = "${var.clusterName}-worker"
      propagate_at_launch = true
    }
  ], data.null_data_source.tags.*.outputs)

  depends_on = [
    aws_launch_template.worker
  ]
}

resource "aws_autoscaling_schedule" "schdule-worktime" {
  scheduled_action_name = "worktime"
  count = var.schduleActionEnabled
  autoscaling_group_name = aws_autoscaling_group.workers.name
  recurrence = "0 0 * * *"
  desired_capacity = 1
  max_size = 3
  min_size = 1
}

resource "aws_autoscaling_schedule" "schdule-non-worktime" {
  scheduled_action_name = "non-worktime"
  count = var.schduleActionEnabled
  autoscaling_group_name = aws_autoscaling_group.workers.name
  recurrence = "0 15 * * *"
  desired_capacity = 0
  max_size = 0
  min_size = 0
}

locals {
  extra_tags_keys = keys(var.extra_tags)
  extra_tags_values = values(var.extra_tags)
}

data "null_data_source" "tags" {
  count = length(keys(var.extra_tags))

  inputs = {
    key = local.extra_tags_keys[count.index]
    value = local.extra_tags_values[count.index]
    propagate_at_launch = true
  }
}