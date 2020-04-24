output "aws_vpc_id" {
  description = "VPC id"
  value = module.networks.aws_vpc_id
}

output "aws_nat_eip" {
  description = "NAT elastic ip"
  value = module.networks.nat_eip
}
