resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "prod-pub-sub-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub-1"
  }
}

resource "aws_subnet" "prod-pub-sub-2" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "prod-pub-sub-2"
  }
}

resource "aws_subnet" "prod-priv-sub-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-priv-sub-1"
  }
}

resource "aws_subnet" "prod-priv-sub-2" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-priv-sub-2"
  }
}

resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }

  // Other attributes for the route table go here...
}


resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.prod-ngw.id
  }

  // Other attributes for the route table go here...
}


resource "aws_route_table_association" "pub-route_table_association" {
  subnet_id      = aws_subnet.prod-pub-sub-1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


resource "aws_route_table_association" "priv-route_table_association" {
  subnet_id      = aws_subnet.prod-priv-sub-1.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

resource "aws_route_table_association" "pub-route_table_association2" {
  subnet_id      = aws_subnet.prod-pub-sub-2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}

resource "aws_route_table_association" "priv-route_table_association2" {
  subnet_id      = aws_subnet.prod-priv-sub-2.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-igw"
  }
}


resource "aws_eip" "nat_gateway" {

}

resource "aws_nat_gateway" "prod-ngw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.prod-priv-sub-1.id
  
  tags = {
    "Name" = "test_nat_gateway"
  }
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}