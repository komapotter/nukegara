variable "aws_region" {}
variable "svc_name" {}
variable "acm_domain" {}
variable "app_domain" {
  type = list(string)
}
