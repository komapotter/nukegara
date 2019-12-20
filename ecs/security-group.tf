# ECS instance
resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.svc_name}_ecs_instance_sg"
  description = "Allow inbound traffic for ECS instance"
  vpc_id      = aws_default_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS service(awsvpc mode)
resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.svc_name}_ecs_service_sg"
  description = "Allow inbound traffic for ECS service"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.svc_name}_alb_sg"
  description = "Allow inbound traffic for ALB"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
