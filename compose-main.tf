variable "region" {}

provider "aws" {
  region = "${var.region}"
}

//terraform {
//  backend "s3" {
//    bucket = "state-bucket-by-terraform"
//    key = "statefiles/latest/statefile"
//    region = "eu-central-1"
//  }
//}