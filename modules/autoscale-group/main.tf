data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "runner" {
  most_recent = true

  filter {
    name   = "tag:ami_family"
    values = ["gitlab-runner"]
  }
  owners = ["991604069872"] # Canonical
}

data "template_file" "startup-script" {
  template = file(format("%s/startup-script.sh.tpl", path.module))
  vars = {
    gitlab_runner_coordinator_url = var.gitlab_instance_url
    gitlab_runner_registration_token = var.gitlab_runner_registration_token
    gitlab_runner_description = var.gitlab_runner_description
    gitlab_runner_executor = var.gitlab_runner_executor
  }
}

resource "aws_launch_template" "instance_template" {
  image_id               = data.aws_ami.runner.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.sg_private_id]
  key_name               = var.key_name
  user_data = base64encode(data.template_file.startup-script.rendered)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "runner" {
  vpc_zone_identifier = [var.private_subnet_id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2

  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }

  depends_on = [var.rta_prv]
}

resource "aws_launch_template" "bastion_template" {
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_public_id]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  vpc_zone_identifier = [var.public_subnet_id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.bastion_template.id
    version = "$Latest"
  }
}