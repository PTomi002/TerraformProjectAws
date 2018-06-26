variable "vpc_id" {}
variable "cidr_block" {}
variable "subnet_id" {}
variable "inet_gw_id" {}

resource "aws_route_table" "route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "${var.cidr_block}"
    gateway_id = "${var.inet_gw_id}"
  }

  tags {
    Name = "route-table-by-basic-terraform-project"
  }
}

output "rt_id" {
  value = "${aws_route_table.route_table.id}"
}