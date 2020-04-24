variable "access_key" {
  type    = string
}

variable "secret_key" {
  type    = string
}

variable "default_region" {
  type    = string
}

variable "default_zone" {
  type    = string
}

variable "key_name" {
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