provider "aws" {
  region     = var.default_region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "networks" {
  source = "./modules/network"

  zone = var.default_zone
}

module "instance_groups" {
  source = "./modules/autoscale-group"

  zone = var.default_zone
  key_name = var.key_name
  runner_ami_owner_id = var.runner_ami_owner_id
  vpc_id = module.networks.aws_vpc_id
  sg_private_id = module.networks.aws_sg_prv_id
  private_subnet_id = module.networks.aws_prv_subnet_id
  sg_public_id = module.networks.aws_sg_pub_id
  public_subnet_id = module.networks.aws_pub_subnet_id
  rta_prv = module.networks.rta_prv
  no_of_runners = var.no_of_runners
  gitlab_instance_url = var.gitlab_instance_url
  gitlab_runner_registration_token = var.gitlab_runner_registration_token
  gitlab_runner_executor = var.gitlab_runner_executor
}