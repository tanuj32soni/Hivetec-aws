output "aws_vpc_id" {
  description = "VPC id"
  value = aws_vpc.terraform-vpc.id
}

output "aws_pub_subnet_id" {
  description = "Public subnet id"
  value = aws_subnet.terraform-pub-subent.id
}

output "aws_prv_subnet_id" {
  description = "Private subnet id"
  value = aws_subnet.terraform-prv-subent.id
}

output "aws_ig_id" {
  description = "Internet gateway id"
  value = aws_internet_gateway.internet-gateway.id
}

output "nat_eip" {
  description = "Nat gateway Elastic IP"
  value = aws_eip.nat-ip.id
}

output "aws_ng_id" {
  description = "Internet gateway id"
  value = aws_nat_gateway.nat-gateway.id
}

output "aws_sg_pub_id" {
  description = "Public security group id"
  value = aws_security_group.allow_ssh_public.id
}

output "aws_sg_prv_id" {
  description = "Private security group id"
  value = aws_security_group.allow_ssh_private.id
}
