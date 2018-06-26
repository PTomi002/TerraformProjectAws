variable "instance_number" {}
variable "username" {}
variable "password" {}
variable "ssecurity_group_id" {
  type = "list"
}
variable "restore_from_snapshot" {}
variable "db_sn_name" {}

resource "aws_rds_cluster" "cluster" {
  master_username = "${var.username}"
  master_password = "${var.password}"
  db_subnet_group_name = "${var.db_sn_name}"
  skip_final_snapshot = true
  snapshot_identifier       = "${var.restore_from_snapshot}"

  vpc_security_group_ids = [
    "${var.ssecurity_group_id}"]

  tags {
    Name = "rds-cluster-by-basic-terraform-project"
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = "${var.instance_number}"
  cluster_identifier = "${aws_rds_cluster.cluster.id}"
  instance_class = "db.t2.small"
  db_subnet_group_name = "${var.db_sn_name}"

  tags {
    Name = "rds-instance-by-basic-terraform-project"
  }
}