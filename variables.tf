# this is the port we'll be serving traffic on; while we
# can use any port (including the default (5000)),
# it's just easier to use the standard HTTP port

variable "port" {
  default     = "80"
  description = "the port to use to serve the application"
}

# this is the owner of the AMI; we need it to restrict
# the AMI query so we only grab the AMI we own, regardless
# of what other owners' AMIs are called

variable "owner" {
  default     = "688772714249"
  description = "the owner of the AMI"
}

# this is the domainname we'll be using; it's used
# to set the zone for Route53 and for creating
# the alias to the EC2 instance we're running

variable "domain" {
  default     = "kdaweb.com"
  description = "the domain name to use"
}

# this is the hostname for the EC2 instance

variable "hostname" {
  default     = "fcc"
  description = "the hostname to use"
}

# this is the name of the AMI we'll be instantiating"

variable "ami_name" {
  default     = "flexioncodechallenge"
  description = "the name of the AMI to use"
}

# this is the S3 bucket where we'll be storing remote state

variable "remote-state-bucket" {
  default     = "com.kdaweb.terraform-remote-state"
  description = "the bucket where we'll store remote state"
}

# this is the name of the application

variable "application" {
  default     = "fcc"
  description = "the name of the application"
}

# this is the environment for the application

variable "environment" {
  default     = "development"
  description = "the envrionment for the application"
}

# this is the region in which we'll be serving

variable "region" {
  default     = "us-east-1"
  description = "the region where the magic happens"
}

# this is the instance type we'll be creating

variable "instance_type" {
  default     = "t2.micro"
  description = "the type of EC2 instance to use"
}

# this is where teh application will live

variable "application_location" {
  default = "/application/"
  description = "where the application will live"
}

variable "sgs" {
  default = ["sg-00fbabd161fd1dc5f"]
  description = "web-only SG for port 80"
}