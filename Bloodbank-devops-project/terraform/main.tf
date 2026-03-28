provider "aws" {
  
  region = "ap-south-1"

}

# Creating VPC B
resource "aws_vpc" "B" {

    cidr_block = var.cidr_vpc


  }

# Creating Subnet for VPC B 
resource "aws_subnet" "subnet_vpc_B" {

    vpc_id = aws_vpc.B.id

    cidr_block = var.subnet_cidr

  }

# Creating Internet Gateway for VPC B
resource "aws_internet_gateway" "vpc_B_igw" {

    vpc_id = aws_vpc.B.id
  
}

# Creating Route Table for VPC B
resource "aws_route_table" "vpc_B_route_table" {

    vpc_id = aws_vpc.B.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_B_igw.id

    }
    route {
        cidr_block = var.cidr_vpc_c
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_C_peering.id
    }

}

# Associating Route Table with Subnet in VPC B
resource "aws_route_table_association" "vpc_B_subnet_association" {

    subnet_id = aws_subnet.subnet_vpc_B.id

    route_table_id = aws_route_table.vpc_B_route_table.id

}


#Creating Security Group for VPC B
resource "aws_security_group" "vpc_B_sg" {  

    name = "vpc_B_sg"

    description = "Security Group for VPC B"

    vpc_id = aws_vpc.B.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Creating VPC C
resource "aws_vpc" "vpc_C" {


    cidr_block = var.cidr_vpc_c
  
}

# Creating Subnet for VPC C
resource "aws_subnet" "vpc_C_subnet" {

    vpc_id = aws_vpc.vpc_C.id

    cidr_block = var.subnet_cidr_vpc_c
  
}



resource "aws_internet_gateway" "vpc_C_igw" {

    vpc_id = aws_vpc.vpc_C.id
  
}
#peering connection between VPC B and VPC C
resource "aws_vpc_peering_connection" "vpc_B_C_peering" {

    vpc_id = aws_vpc.B.id

    peer_vpc_id = aws_vpc.vpc_C.id

    auto_accept = true
  
}



resource "aws_route_table" "vpc_C_route_table" {

    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_D
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_D_peering.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_C_igw.id
    }
    

}


resource "aws_route_table_association" "vpc_C_subnet_association" {

    subnet_id = aws_subnet.vpc_C_subnet.id

    route_table_id = aws_route_table.vpc_C_route_table.id

}


# Creating Route Table for VPC B to route traffic to VPC C

#creating vpc D and subnet for vpc D
resource "aws_vpc" "vpc_D" {


    cidr_block = var.cidr_vpc_D
  
}

resource "aws_subnet" "vpc_D_subnet" {

    vpc_id = aws_vpc.vpc_D.id

    cidr_block = var.subnet_cidr_vpc_D
  
}


#peering connection between VPC C and VPC D
resource "aws_vpc_peering_connection" "vpc_C_D_peering" {

    vpc_id = aws_vpc.vpc_C.id

    peer_vpc_id = aws_vpc.vpc_D.id

    auto_accept = true
  
}





resource "aws_key_pair" "vpc_B_key" {
    key_name = "my-key-pair"
    public_key = var.key
}

resource "aws_instance" "Jump_Box" {

    ami = var.ami

    instance_type = var.instance_type

    associate_public_ip_address = true 

     key_name = aws_key_pair.vpc_B_key.key_name

    subnet_id = aws_subnet.subnet_vpc_B.id

    security_groups = [aws_security_group.vpc_B_sg.id]   

    tags = {
        Name = "Jump_Box"
    }
  
}


resource "aws_security_group" "vpc_C_sg" {  

    name = "vpc_C_sg"

    description = "Security Group for VPC C"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["10.0.4.0/24"]

    }

}



resource "aws_instance" "vpc_C_instance" {

    ami = var.ami

    instance_type = var.instance_type

     key_name = aws_key_pair.vpc_B_key.key_name

     associate_public_ip_address = false

     subnet_id = aws_subnet.vpc_C_subnet.id

    security_groups = [aws_security_group.vpc_C_sg.id]

    tags = {
        Name = "proxy_instance"
    }
  
}
























