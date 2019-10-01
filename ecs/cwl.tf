resource "aws_cloudwatch_log_group" "dummy_api" {
  name = "${var.svc_name}-cluster"

  tags = {
    Service     = var.svc_name
  }
}
