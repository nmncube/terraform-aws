#----networking/main.tf-----

data "aws_availability_zones" "available" {

}

resource "random_integer" "random" {
    min = 1
    max = 100
}

resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "main-vpc-${random_integer.random.id}"
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_subnet" "public_subnet" {
    count = var.public_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "public_subnet_${count.index + 1}"
    }

}

resource "aws_subnet" "private_app_subnet" {
    count = var.private_app_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.private_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "private_app_subnet_${count.index + 1}"
    }
}


resource "aws_route_table_association" "public_assoc" {
    count = var.public_sn_count
    subnet_id = aws_subnet.public_subnet.*.id[count.index]
    route_table_id = aws_route_table.public_rtable.id
}

resource "aws_subnet" "private_data_subnet" {
    count = var.private_data_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.private_data_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "private_data_subnet_${count.index + 1}"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "horizon_igw"
    }
}

resource "aws_route_table" "public_rtable" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "Public_rt"
    }

}

resource "aws_route" "default_route" {

  route_table_id = aws_route_table.public_rtable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id

}

# resource "aws_default_route_table" "private_rt" {
#     default_route_table_id = aws_vpc.main_vpc.default_route_table_id.id
  
# }


#Security group for EC2 instance 
resource "aws_security_group" "pub_sg" {
  name        = "public_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.access_ip]
   
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  tags = {
    Name = "public_sg"
  }
}
