variable "port" {
  default = "80"
}

provider "aws" {
  region = "us-east-1"
}

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
    values = ["688772714249"]
  }
  
  filter {
    name = "name"
    values = ["flexioncodechallenge"]
  }
}

data "aws_route53_zone" "primary" {
  name = "kdaweb.com."
}

resource "aws_security_group" "fcc" {
  name = "allow port incoming traffic"

  ingress {
    from_port = 0
    to_port = "${var.port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "fcc" {
  ami = "${data.aws_ami.fcc_ami.image_id}"
  instance_type = "t2.micro"
  user_data = "#!/bin/bash\ncd /application/ && sudo port=${var.port} ./verify_temperature.bash\n"
  vpc_security_group_ids = ["${aws_security_group.fcc.id}"]
  tags {
    Name = "fcc"
  }
}

resource "aws_route53_record" "fcc" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "fcc.kdaweb.com"
  type    = "A"
  ttl     = "30"
  records = ["${aws_instance.fcc.public_ip}"]
}
