variable "aws_region" {}
variable "svc_name" {}
variable "acm_domain" {}
variable "app_domain" {
  type = list(string)
}
variable "ec2_image_id" {}
variable "ec2_instance_type" {}
variable "key_name" {}
