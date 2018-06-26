variable "vpc_cidr_block" {}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "vpc-by-basic-terraform-project"
  }
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "sec_group" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}