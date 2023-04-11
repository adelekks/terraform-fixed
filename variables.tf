variable "aws_region" {
  description = "Region for the VPC"
  default = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "ami" {
  description = "Amazon RedHatLinux AMI"
#  default = "ami-06391d741144b83c2"
  default = "ami-00aa0a1b208ece144"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "key_path_priv" {
  description = "SSH private Key path"
  default = "~/.ssh/id_rsa"
}
