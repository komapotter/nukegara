### ECS/Fargate
resource "aws_ecs_cluster" "nukegara" {
  name = "${var.svc_name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_ecs_task_definition" "nukegara" {
  task_definition = aws_ecs_task_definition.nukegara.family
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
      log_stream_prefix = "fargate"
  })

}

resource "aws_ecs_service" "nukegara" {
  name                              = var.svc_name
  cluster                           = aws_ecs_cluster.nukegara.arn
  task_definition                   = "${aws_ecs_task_definition.nukegara.family}:${max(aws_ecs_task_definition.nukegara.revision, data.aws_ecs_task_definition.nukegara.revision)}"
  desired_count                     = 0
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  scheduling_strategy               = "REPLICA"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.ecs_service_sg.id,
    ]

    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_c.id,
    ]
  }

  deployment_controller {
    #type = "ECS"
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nukegara_foo.arn
    container_name   = "app"
    container_port   = 1323
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}


### ECS/EC2
#resource "aws_ecs_cluster" "nukegara_ec2" {
#  name               = "${var.svc_name}-ec2-cluster"
##  capacity_providers = ["nukegara_ec2_cp"]
##  default_capacity_provider_strategy {
##    capacity_provider = "nukegara_ec2_cp"
##    weight            = "100"
##  }
#  setting {
#    name  = "containerInsights"
#    value = "enabled"
#  }
#}

data "aws_ecs_task_definition" "nukegara_ec2" {
  task_definition = aws_ecs_task_definition.nukegara_ec2.family
}

resource "aws_ecs_task_definition" "nukegara_ec2" {
  family                   = "${var.svc_name}-ec2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = templatefile("container_ec2_tpl.json",
    {
      app_image_repo = "${aws_ecr_repository.nukegara.repository_url}:latest"

      log_group         = aws_cloudwatch_log_group.nukegara.name
      log_region        = var.aws_region
      log_stream_prefix = "ec2"
  })

  volume {
    name      = "my-vol"
    host_path = "/var/www/my-vol"
  }

}

#resource "aws_ecs_service" "nukegara_ec2" {
#  name                = "${var.svc_name}-ec2"
#  cluster             = aws_ecs_cluster.nukegara_ec2.arn
#  task_definition     = "${aws_ecs_task_definition.nukegara_ec2.family}:${max(aws_ecs_task_definition.nukegara_ec2.revision, data.aws_ecs_task_definition.nukegara_ec2.revision)}"
#  desired_count       = 0
#  launch_type         = "EC2"
#  scheduling_strategy = "REPLICA"
#  #  health_check_grace_period_seconds = 30
#
#  network_configuration {
#    assign_public_ip = false
#    security_groups = [
#      aws_security_group.ecs_instance_sg.id,
#      aws_security_group.ecs_service_sg.id,
#    ]
#
#    subnets = [
#      aws_subnet.private.id,
#    ]
#  }
#
#  deployment_controller {
#    type = "ECS"
#  }
#
#  #  load_balancer {
#  #    target_group_arn = aws_lb_target_group.nukegara.arn
#  #    container_name   = "app"
#  #    container_port   = 1323
#  #  }
#
#  lifecycle {
#    ignore_changes = [desired_count]
#  }
#}

#resource "aws_ecs_capacity_provider" "nukegara_ec2" {
#  name = "nukegara_ec2_cp"
#
#  auto_scaling_group_provider {
#    auto_scaling_group_arn         = aws_autoscaling_group.nukegara.arn
#    managed_termination_protection = "ENABLED"
#
#    managed_scaling {
#      maximum_scaling_step_size = 1
#      minimum_scaling_step_size = 1
#      status                    = "ENABLED"
#      target_capacity           = 1
#    }
#  }
#}
