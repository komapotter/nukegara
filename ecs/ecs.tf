resource "aws_ecs_cluster" "nukegara" {
  name = "${var.svc_name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "nukegara" {
  family                   = var.svc_name
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = templatefile("container_tpl.json",
    {
      app_image_repo = "${aws_ecr_repository.nukegara.repository_url}:latest"

      log_group         = aws_cloudwatch_log_group.nukegara.name
      log_region        = var.aws_region
      log_stream_prefix = "admin"
  })

}

resource "aws_ecs_service" "nukegara" {
  name                              = var.svc_name
  cluster                           = aws_ecs_cluster.nukegara.arn
  task_definition                   = aws_ecs_task_definition.nukegara.arn
  desired_count                     = 0
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"
  scheduling_strategy               = "REPLICA"
#  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_service_sg.id]

    subnets = [
      aws_default_subnet.default_a.id,
      aws_default_subnet.default_c.id,
    ]
  }

  deployment_controller {
    type = "ECS"
  }

#  load_balancer {
#    target_group_arn = aws_lb_target_group.nukegara.arn
#    container_name   = "app"
#    container_port   = 1323
#  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
