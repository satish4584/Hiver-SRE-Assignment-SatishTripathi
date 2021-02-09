resource "aws_vpc" "prod_vpc" {
  cidr_block       = var.vpc_cidr
  tags {
    Name = "ProdVPC"
  }
}
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags {
    Name = "main"
  }
}

resource "aws_subnet" "private" {
  count = length(var.subnets_cidr)
  vpc_id = aws_vpc.prod_vpc.id
  cidr_block = element(var.subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags {
    Name = "Subnet-${count.index+1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags {
    Name = "publicRouteTable"
  }
}

resource "aws_route_table_association" "a" {
  count = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}