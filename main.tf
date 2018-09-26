# This is our starting point, traditionally named 'main.tf'
#
# The majority of the configuration takes place in other
# locations, including:
#
#   * variables.tf : variables that can be set
#   * data.tf      : data source queries
#   * resources.tf : the resources (EC2 instance, etc.) created
#
# Here, we're just going to specify the provider and set the AWS
# region name and setup remote state storage

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "${var.remote-state-bucket}"
    key    = "${var.application}/${var.environment}/terraform.tfstate"
    region = "${var.region}"
  }
}
