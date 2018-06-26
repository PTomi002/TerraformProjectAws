variable "instance_type" {}
variable "subnet_id" {}
variable "key_name" {}
variable "sec-gr-ids" {
  type = "list"
}

locals {
  letter_prefix = "X"
}

resource "random_string" "random" {
  length = 2
  special = false
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "root-device-type"
    values = [
      "ebs"]
  }

  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami = "${data.aws_ami.amazon_linux.image_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  user_data = "${file("ec2/instance/user_data.txt")}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups = [
    "${var.sec-gr-ids}"]

  lifecycle {
    ignore_changes = ["security_groups"]
  }

  tags {
    Name = "${local.letter_prefix}${random_string.random.result}-by-basic-terraform-project"
  }
}

output "ec2_instance_pub_inet" {
  value = "${aws_instance.ec2_instance.public_ip}"
}

output "instance_id" {
  value = "${aws_instance.ec2_instance.id}"
}