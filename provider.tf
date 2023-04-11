# Define AWS as our provider
provider "aws" {
#  region = "var.aws_region"
  region = "${var.aws_region}"
}
