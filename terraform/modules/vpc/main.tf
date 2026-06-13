resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true    
  enable_dns_hostnames = true
  
  tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
  
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags =  merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

# Public Subnet
resource "aws_subnet" "public" {
    count = length(var.public_subnets)

    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-public-${count.index+1}"
       "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/${var.project_name}" = "shared"
    }
  )
}

#Private subnet
resource "aws_subnet" "private" {
    count = length(var.private_subnets)

    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_subnets[count.index]
    availability_zone = var.availability_zones[count.index]
    
tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-public-${count.index+1}"
       "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/${var.project_name}" = "shared"
    }
  )
}

#Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

#NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )

  depends_on = [
    aws_internet_gateway.gw
  ]
}


# Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

 tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

resource "aws_route_table_association" "public-route-association" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}


# Private Route Table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

resource "aws_route_table_association" "private-route-association" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route.id
}



# #VPC Endpoint
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${var.region}.s3"
# }