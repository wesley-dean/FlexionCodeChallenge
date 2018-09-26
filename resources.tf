# let's create an EC2 instance that uses the AMI we queried
# before and use 'user_data' to start the Flask development
# server at startup

resource "aws_instance" "fcc" {
  ami                    = "${data.aws_ami.fcc_ami.image_id}"
  instance_type          = "${var.instance_type}"
  user_data              = "#!/bin/bash\ncd ${var.application_location} && sudo port=${var.port} envrionment=${var.environment} ./verify_temperature.bash\n"
  vpc_security_group_ids = ["${var.sgs}"]

  tags {
    Name = "${var.application}"
  }
}

# finally, we also want to associate a DNS hostname (an alias created
# through Route53) that points to the public IP address of the EC2 instance
# we're running; the Time To Live (TTL) is set to 30 seconds so that if (when)
# we rebuild the image, the old IP address won't live in the cache for a long time

resource "aws_route53_record" "fcc" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.hostname}.${var.domain}"
  type    = "A"
  ttl     = "30"
  records = ["${aws_instance.fcc.public_ip}"]
}
