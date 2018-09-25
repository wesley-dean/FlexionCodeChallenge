# while we can use any port (including the default (5000)),
# it's just easier to use the standard HTTP port

variable "port" {
  default = "80"
  description = "the port to use to serve the application"
}


variable "owner" {
	default = "688772714249"
	description = "the owner of the AMI"
}

variable "domain" {
	default = "kdaweb.com"
	description = "the domain name to use"
}

variable "hostname" {
	default = "fcc"
	description = "the hostname to use"
}