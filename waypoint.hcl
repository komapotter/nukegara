project = "nukegara-waypoint"

app "nukegara-waypoint" {
  labels = {
    "service" = "nukegara-waypoint",
    "env" = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "aws-ecr" {
        region = "ap-northeast-1"
        repository = "nukegara"
        tag = "latest"
      }
    }
  }

  deploy {
    use "aws-ecs" {
      region = "ap-northeast-1"
      memory = "512"
      task_role_name = "ecr-nukegara-waypoint"
    }
  }
}
