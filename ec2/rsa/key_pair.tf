variable "key_name" {}
variable "pub_key" {}

resource "aws_key_pair" "key_pair" {
  key_name = "${var.key_name}"
  public_key = "${var.pub_key}"
}

output "key_name" {
  value = "${aws_key_pair.key_pair.key_name}"
}