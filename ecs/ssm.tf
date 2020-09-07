resource "aws_ssm_parameter" "logentries_uri" {
  name  = "logentries_url"
  type  = "SecureString"
  value = var.logentries_uri
}
