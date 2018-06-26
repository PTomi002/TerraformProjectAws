variable "vpc_cidr_block" {}
variable "sn_azone_1" {}
variable "sn_azone_2" {}
variable "sn_1_cidr_block" {}
variable "sn_2_cidr_block" {}
variable "sn_3_cidr_block" {}
variable "sn_4_cidr_block" {}

module "vpc" {
  source = "network/vpc"
  vpc_cidr_block = "${var.vpc_cidr_block}"
}

module "sn-1-pub" {
  source = "network/subnet"
  cidr_block = "${var.sn_1_cidr_block}"
  vpc_id = "${module.vpc.vpc_id}"
  availability_zone = "${var.sn_azone_1}"
}

module "sn-2-pub" {
  source = "network/subnet"
  cidr_block = "${var.sn_2_cidr_block}"
  vpc_id = "${module.vpc.vpc_id}"
  availability_zone = "${var.sn_azone_2}"
}

module "sn-3-priv" {
  source = "network/subnet"
  cidr_block = "${var.sn_3_cidr_block}"
  vpc_id = "${module.vpc.vpc_id}"
  availability_zone = "${var.sn_azone_1}"
}

module "sn-4-priv" {
  source = "network/subnet"
  cidr_block = "${var.sn_4_cidr_block}"
  vpc_id = "${module.vpc.vpc_id}"
  availability_zone = "${var.sn_azone_2}"
}

module "inet-gw" {
  source = "network/gw/inet"
  vpc_id = "${module.vpc.vpc_id}"
}

module "rt-sn-pub" {
  source = "network/routetable/rt"
  inet_gw_id = "${module.inet-gw.inet_gw_id}"
  subnet_id = "${module.sn-1-pub.subnet_id}"
  cidr_block = "0.0.0.0/0"
  vpc_id = "${module.vpc.vpc_id}"
}

module "rt-sn-1-pub-assoc" {
  source = "network/routetable/assoc"
  rt_id = "${module.rt-sn-pub.rt_id}"
  sn_id = "${module.sn-1-pub.subnet_id}"
}

module "rt-sn-2-pub-assoc" {
  source = "network/routetable/assoc"
  rt_id = "${module.rt-sn-pub.rt_id}"
  sn_id = "${module.sn-2-pub.subnet_id}"
}

module "sg-allow-http" {
  source = "network/security"
  security_group_ids = [
    "${module.sg-alb-access.security_group_id}"]
  port_from = "80"
  port_to = "80"
  vpc_id = "${module.vpc.vpc_id}"
}

module "sg-allow-ssh-bastion" {
  source = "network/security"
  port_from = "22"
  port_to = "22"
  from_cidr = [
    "0.0.0.0/0"]
  vpc_id = "${module.vpc.vpc_id}"
}

module "sg-allow-ssh" {
  source = "network/security"
  port_from = "22"
  port_to = "22"
  security_group_ids = [
    "${module.sg-allow-ssh-bastion.security_group_id}"]
  vpc_id = "${module.vpc.vpc_id}"
}

module "sg-alb-access" {
  source = "network/security"
  from_cidr = [
    "0.0.0.0/0"]
  port_from = "80"
  port_to = "80"
  vpc_id = "${module.vpc.vpc_id}"
}

module "sg-rds-allow-from-public" {
  source = "network/security"
  port_from = "3306"
  port_to = "3306"
  vpc_id = "${module.vpc.vpc_id}"
  security_group_ids = [
    "${module.sg-allow-ssh.security_group_id}",
    "${module.sg-allow-http.security_group_id}"]
}