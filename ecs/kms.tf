resource "aws_kms_key" "tfvars" {}

resource "aws_kms_alias" "tfvars" {
  name          = "alias/terraform-variables"
  target_key_id = aws_kms_key.tfvars.key_id
}
