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
      "description": "Expire images more than 5",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

}
