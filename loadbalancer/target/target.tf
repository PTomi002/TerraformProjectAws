variable "target_group_arn" {}
variable "target_id" {}

resource "aws_lb_target_group_attachment" "target" {
  target_group_arn = "${var.target_group_arn}"
  target_id = "${var.target_id}"
  port = 80
}