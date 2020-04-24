variable "zone" {
  type    = string
  default = "us-east-2a"
}

variable "no_of_runners" {
  type = number
}

variable "runner_ami_owner_id" {
  type = string
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

variable "gitlab_instance_url" {
  type = string
  default = "https://gitlab.com/"
}

variable "gitlab_runner_registration_token" {
  type = string
}

variable "gitlab_runner_description" {
  type = string
  default = "Runner"
}

variable "gitlab_runner_executor" {
  type = string
  default = "shell"
}

variable "rta_prv" {
  type = string
}





