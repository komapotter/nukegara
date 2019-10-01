resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_a" {
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Default subnet for ap-northeast-1a"
  }
}

resource "aws_default_subnet" "default_c" {
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "Default subnet for ap-northeast-1c"
  }
}

resource "aws_default_subnet" "default_d" {
  availability_zone = "${var.aws_region}d"

  tags = {
    Name = "Default subnet for ap-northeast-1d"
  }
}
