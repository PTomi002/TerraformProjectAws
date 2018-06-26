variable "vpc_id" {}
variable "port_from" {}
variable "port_to" {}
variable "from_cidr" {
  type = "list"
  default = []
}
variable "security_group_ids" {
  type = "list"
  default = []
}
variable "self" {
  default = false
}

resource "aws_security_group" "security_group" {
  vpc_id = "${var.vpc_id}"

  ingress {
    self = "${var.self}"
    security_groups = ["${var.security_group_ids}"]
    from_port = "${var.port_from}"
    to_port = "${var.port_to}"
    protocol = "tcp"
    cidr_blocks = [
      "${var.from_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "security-group-by-basic-terraform-project"
  }
}

output "security_group_id" {
  value = "${aws_security_group.security_group.id}"
}