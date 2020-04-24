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

resource "aws_launch_template" "instance_template" {
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.sg_private_id]
  key_name               = var.key_name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "runner" {
  vpc_zone_identifier = [var.private_subnet_id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }
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