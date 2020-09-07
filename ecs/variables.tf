variable "aws_region" {}
variable "cidr_block" {}
variable "svc_name" {}
variable "acm_domain" {}
variable "app_domain" {
  type = list(string)
}
variable "ec2_image_id" {}
variable "ec2_instance_type" {}
variable "key_name" {}
variable "logentries_host" {}
variable "logentries_uri" {}
