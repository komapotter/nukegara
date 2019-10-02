resource "aws_lb" "nukegara" {
  name                       = "${var.svc_name}-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = true

  subnets = [
    aws_default_subnet.default_a.id,
    aws_default_subnet.default_c.id,
  ]

  security_groups = [
    aws_security_group.alb_sg.id,
  ]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.nukegara.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.tokyo.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Authorized Access"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "nukegara" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nukegara.arn
  }

  condition {
    field  = "host-header"
    values = var.app_domain
  }
}

resource "aws_lb_target_group" "nukegara" {
  name                 = "${var.svc_name}-tg"
  vpc_id               = aws_default_vpc.default.id
  target_type          = "ip"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = 1323
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.nukegara]
}
