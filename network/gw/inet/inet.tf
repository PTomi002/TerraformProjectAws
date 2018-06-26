variable "vpc_id" {}

resource "aws_internet_gateway" "inet_gw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "inet-gw-by-basic-terraform-project"
  }
}

output "inet_gw_id" {
  value = "${aws_internet_gateway.inet_gw.id}"
}