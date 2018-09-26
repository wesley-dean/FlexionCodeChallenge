# This is our starting point, traditionally named 'main.tf'
#
# The majority of the configuration takes place in other
# locations, including:
#   * variables.tf : variables that can be set
#   * data.tf      : data source queries
#   * resources.tf : the resources (EC2 instance, etc.) created

provider "aws" {
  region = "us-east-1"
}
