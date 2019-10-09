provider "aws" {
  profile    = "default"
  region     = "${var.region}"
}

resource "aws_key_pair" "tf200-kitchen-test" {
  key_name = "tf200-kitchen-test"
  public_key =  "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "example" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "tf200-kitchen-test"
}