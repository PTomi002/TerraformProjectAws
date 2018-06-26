variable "vpc_id" {}
variable "subnet_ids" {
  type = "list"
}
variable "security_group_ids" {
  type = "list"
}

resource "aws_lb" "alb" {
  security_groups = ["${var.security_group_ids}"]
  subnets = [
    "${var.subnet_ids}"]

  tags {
    Name = "alb-by-basic-terraform-project"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.id}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.target_group.id}"
    type = "forward"
  }
}

resource "aws_lb_target_group" "target_group" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "target-group-by-basic-terraform-project"
  }
}

output "target_group_arn" {
  value = "${aws_lb_target_group.target_group.id}"
}