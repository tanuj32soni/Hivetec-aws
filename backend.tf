terraform {
  backend "s3" {
    bucket = "terraform-tech"
    key    = "terraform-state"
    region = "us-east-2"
  }
}