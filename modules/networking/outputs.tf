output "public_subnets_ids" {
 value = [for i , v in aws_subnet.public_subnet :  v.id]
}

output "private_subnets_ids" {
  value = [for i , v in aws_subnet.private_subnet :  v.id]
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}