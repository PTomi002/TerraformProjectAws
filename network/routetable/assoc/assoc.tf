variable "sn_id" {}
variable "rt_id" {}

resource "aws_route_table_association" "association" {
  subnet_id = "${var.sn_id}"
  route_table_id = "${var.rt_id}"
}