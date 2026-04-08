resource "aws_vpc" "vpc_A" {
    cidr_block = var.cidr_vpc_A
    tags = {
        Name = "vpc_A"
    }
}

resource "aws_vpc" "B" {
    cidr_block = var.cidr_vpc_B
    tags = {
        Name = "vpc_B"
    }
}

resource "aws_vpc" "vpc_C" {
    cidr_block = var.cidr_vpc_C
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "vpc_C"
    }
}


###subnets


resource "aws_subnet" "subnet_A" {
    vpc_id = aws_vpc.vpc_A.id
    cidr_block = var.subnet_cidr_vpc_A
    tags = {
        Name = "subnet_A"
    }


}


resource "aws_subnet" "subnet_vpc_B" {
    vpc_id = aws_vpc.B.id
    
    cidr_block = var.subnet_cidr_vpc_B
    tags = {
        Name = "subnet_vpc_B"
    }
}


data "aws_availability_zones" "available" {
  state = "available"
}



resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id    = data.aws_availability_zones.available.zone_ids[0]
    cidr_block = var.subnet_cidr_vpc_c1
    tags = {
        Name = "vpc_C_subnet1"
    }
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id = data.aws_availability_zones.available.zone_ids[1]
    map_public_ip_on_launch = false
    cidr_block = var.subnet_cidr_vpc_c2
    tags = {
        Name = "vpc_C_subnet2"
    }
}

resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id = data.aws_availability_zones.available.zone_ids[2]
    cidr_block = var.subnet_cidr_vpc_c3
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc_C_subnet3"

    }
}

resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id = data.aws_availability_zones.available.zone_ids[2]
    cidr_block = var.subnet_cidr_vpc_c4
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc_C_subnet3"

    }
}


