resource "aws_ecr_repository" "nukegara" {
  name = var.svc_name
}

resource "aws_ecr_lifecycle_policy" "nukegara" {
  repository = aws_ecr_repository.nukegara.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images more than 20",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["created"],
        "countType": "imageCountMoreThan",
        "countNumber": 20
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

}
