resource "aws_codedeploy_app" "nukegara" {
  compute_platform = "ECS"
  name             = "${var.svc_name}-app"
}

resource "aws_codedeploy_deployment_group" "nukegara" {
  app_name               = aws_codedeploy_app.nukegara.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.svc_name}-group"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.nukegara.name
    service_name = aws_ecs_service.nukegara.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_lb_listener.https.arn}"]
      }

      target_group {
        name = aws_lb_target_group.nukegara_foo.name
      }

      target_group {
        name = aws_lb_target_group.nukegara_bar.name
      }
    }
  }
}
