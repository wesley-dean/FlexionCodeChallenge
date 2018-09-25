data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  availability_zone = "us-east-1b"
  default_for_az = true
}

data "aws_ami" "fcc_ami" {
  most_recent = true

  filter {
    name = "owner-id"
    values = ["${var.owner}"]
  }

  filter {
    name = "name"
    values = ["flexioncodechallenge"]
  }
}

data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}