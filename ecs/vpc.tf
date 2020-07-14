data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "koma-vpc"
  }
}

# public
resource "aws_subnet" "public_a" {
  availability_zone = "${var.aws_region}a"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "koma-public-a"
  }
}

resource "aws_subnet" "public_c" {
  availability_zone = "${var.aws_region}c"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "koma-public-c"
  }
}

# private
resource "aws_subnet" "private_a" {
  availability_zone = "${var.aws_region}a"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 3)
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "koma-private-a"
  }
}

resource "aws_subnet" "private_c" {
  availability_zone = "${var.aws_region}c"
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 4)
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "koma-private-c"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "koma-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "koma-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "koma-private-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_c.id
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_route_table_association" "private_c" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_c.id
}

#resource "aws_vpc_endpoint" "s3" {
#  vpc_id            = aws_vpc.main.id
#  service_name      = "com.amazonaws.ap-northeast-1.s3"
#  vpc_endpoint_type = "Gateway"
#}
#
#resource "aws_vpc_endpoint_route_table_association" "private_s3" {
#  vpc_endpoint_id = aws_vpc_endpoint.s3.id
#  route_table_id  = aws_route_table.private.id
#}
#
#resource "aws_vpc_endpoint" "ecr" {
#  vpc_id            = aws_vpc.main.id
#  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
#  vpc_endpoint_type = "Interface"
#
#  security_group_ids = [
#    aws_security_group.vpc_endpoint_sg.id,
#  ]
#
#  subnet_ids = [
#    aws_subnet.private.id,
#  ]
#
#  private_dns_enabled = true
#}
#
#resource "aws_vpc_endpoint" "cwl" {
#  vpc_id            = aws_vpc.main.id
#  service_name      = "com.amazonaws.ap-northeast-1.logs"
#  vpc_endpoint_type = "Interface"
#
#  security_group_ids = [
#    aws_security_group.vpc_endpoint_sg.id,
#  ]
#
#  subnet_ids = [
#    aws_subnet.private.id,
#  ]
#
#  private_dns_enabled = true
#}


### defalut network
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
