variable "instance_type" {}
variable "pub_key" {}

resource "random_string" "key-name" {
  length = 16
  special = false
}

module "key-pair" {
  source = "ec2/rsa"
  key_name = "${random_string.key-name.result}"
  pub_key = "${var.pub_key}"
}

module "ec2-in-1-pub" {
  source = "ec2/instance"
  instance_type = "${var.instance_type}"
  subnet_id = "${module.sn-1-pub.subnet_id}"
  key_name = "${module.key-pair.key_name}"
  sec-gr-ids = [
    "${module.sg-allow-ssh.security_group_id}",
    "${module.sg-allow-http.security_group_id}"]
}

module "ec2-in-2-pub" {
  source = "ec2/instance"
  instance_type = "${var.instance_type}"
  subnet_id = "${module.sn-2-pub.subnet_id}"
  key_name = "${module.key-pair.key_name}"
  sec-gr-ids = [
    "${module.sg-allow-ssh.security_group_id}",
    "${module.sg-allow-http.security_group_id}"]
}

module "bastion" {
  source = "ec2/instance"
  instance_type = "${var.instance_type}"
  subnet_id = "${module.sn-1-pub.subnet_id}"
  key_name = "${module.key-pair.key_name}"
  sec-gr-ids = [
    "${module.sg-allow-ssh-bastion.security_group_id}"]
}

module "alb" {
  source = "loadbalancer/alb"
  security_group_ids = [
    "${module.sg-alb-access.security_group_id}"]
  subnet_ids = [
    "${module.sn-1-pub.subnet_id}",
    "${module.sn-2-pub.subnet_id}"]
  vpc_id = "${module.vpc.vpc_id}"
}

module "target-1" {
  source = "loadbalancer/target"
  target_group_arn = "${module.alb.target_group_arn}"
  target_id = "${module.ec2-in-1-pub.instance_id}"
}

module "target-2" {
  source = "loadbalancer/target"
  target_group_arn = "${module.alb.target_group_arn}"
  target_id = "${module.ec2-in-2-pub.instance_id}"
}