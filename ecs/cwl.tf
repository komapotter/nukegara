resource "aws_cloudwatch_log_group" "nukegara" {
  name = "${var.svc_name}-cluster"

  tags = {
    Service     = var.svc_name
  }
}
