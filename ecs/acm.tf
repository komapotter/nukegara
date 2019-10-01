data "aws_acm_certificate" "tokyo" {
  domain   = var.acm_domain
  statuses = ["ISSUED"]
}
