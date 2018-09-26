# query this AWS account's default VPC

data "aws_vpc" "default" {
  default = true
}

# query the default subnet from this VPC (the default VPC)

data "aws_subnet" "default" {
  vpc_id            = "${data.aws_vpc.default.id}"
  availability_zone = "us-east-1b"
  default_for_az    = true
}

# query the latest AMI that we own that also matches the
# AMI name we built

data "aws_ami" "fcc_ami" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = ["${var.owner}"]
  }

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}

# query the zone in Route53 for the domainname we want to use

data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}
