variable "sn_group_ids" {
  type = "list"
}

resource "aws_db_subnet_group" "private_subnets" {
  subnet_ids = [
    "${var.sn_group_ids}"]

  tags {
    Name = "sn-group-by-basic-terraform-project"
  }
}

output "db_sn_group_name" {
  value = "${aws_db_subnet_group.private_subnets.name}"
}