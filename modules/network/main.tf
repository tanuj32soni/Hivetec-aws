resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "gitlab-ci"
  }
}

resource "aws_subnet" "terraform-pub-subent" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.zone

  tags = {
    Name = "terraform-pub-subnet"
  }
}

resource "aws_subnet" "terraform-prv-subent" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "terraform-prv-subnet"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "route-table-pub" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "rta-pub" {
  subnet_id      = aws_subnet.terraform-pub-subent.id
  route_table_id = aws_route_table.route-table-pub.id
}

resource "aws_eip" "nat-ip" {
  vpc      = true
  depends_on = [aws_internet_gateway.internet-gateway]
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.terraform-pub-subent.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.internet-gateway]
}

resource "aws_route_table" "route-table-prv" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "rta-prv" {
  subnet_id      = aws_subnet.terraform-prv-subent.id
  route_table_id = aws_route_table.route-table-prv.id
}

resource "aws_security_group" "allow_ssh_private" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_ssh_public" {
  name        = "allow_tls_public"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}