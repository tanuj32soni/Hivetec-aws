variable "zone" {
  type    = string
  default = "us-east-2a"
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "sg_private_id" {
  type = string
}

variable "sg_public_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

