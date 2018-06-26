variable "username" {}
variable "password" {}
variable "restore_from_snapshot" {}

module "db-sn-group" {
  source = "rds/sngroup"
  sn_group_ids = [
    "${module.sn-3-priv.subnet_id}",
    "${module.sn-4-priv.subnet_id}"]
}

module "rds_cluster" {
  source = "rds/cluster"
  restore_from_snapshot = "${var.restore_from_snapshot}"
  db_sn_name = "${module.db-sn-group.db_sn_group_name}"
  instance_number = "2"
  password = "${var.password}"
  username = "${var.username}"
  ssecurity_group_id = [
    "${module.sg-rds-allow-from-public.security_group_id}"]
}