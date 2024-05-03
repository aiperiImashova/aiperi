resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_cidr

  cidr_block = each.value
  vpc_id     = aws_vpc.vpc.id
  availability_zone = each.key
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.name}-public-subnet-${each.key}"
  }

}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  tags = {
    Name = "${var.name}-public-rt"
  }

}

resource "aws_route_table_association" "a" {
  for_each = toset(keys(var.public_subnet_cidr))  
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_subnet[each.key].id 
}

resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_cidr

  cidr_block = each.value
  vpc_id     = aws_vpc.vpc.id
  availability_zone = each.key

  tags = {
    Name = "${var.name}-private-subnet-${each.key}"
    }

}

resource "aws_eip" "my_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id = aws_subnet.public_subnet[var.nat_subnet].id
}

resource "aws_route_table" "aiko_private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }


  tags = { 
    Name = var.name
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each = toset(keys(var.private_subnet_cidr)) 
  
  subnet_id = aws_subnet.private_subnet[each.key].id 
  route_table_id = aws_route_table.aiko_private_rt.id
}

resource "aws_route_table_association" "alb_association" {
  for_each = toset(keys(var.public_subnet_cidr)) 
  subnet_id = aws_subnet.public_subnet[each.key].id  
  route_table_id = aws_route_table.public_rt.id
}


