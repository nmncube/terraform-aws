#----networking/main.tf-----

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
}

resource "aws_subnet" "public_subnet" {
    count = var.public_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]

    tags = {
        Name = "public_subnet_${count.index + 1}"
    }

}

resource "aws_subnet" "private_app_subnet" {
    count = var.private_app_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.private_cidrs[count.index]
    availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]

    tags = {
        Name = "private_app_subnet_${count.index + 1}"
    }
}

resource "aws_subnet" "private_data_subnet" {
    count = var.private_data_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.private_data_cidrs[count.index]
    availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"][count.index]

    tags = {
        Name = "private_data_subnet_${count.index + 1}"
    }
}