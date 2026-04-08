#Routes tables for above vpc

# Creating Route Table for VPC A

resource "aws_route_table" "vpc_A_route_table" {

    vpc_id = aws_vpc.vpc_A.id

    route {
        cidr_block = var.cidr_vpc_B
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_A_peering.id
    }
    route {
        cidr_block = var.cidr_vpc_C
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_A_peering.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_A_igw.id
    }

  
}

resource "aws_route_table" "vpc_B" {
    vpc_id = aws_vpc.B.id

    route {
        cidr_block = var.cidr_vpc_A
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_A_peering.id
    }
    route {
        cidr_block = var.cidr_vpc_C
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_C_peering.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_B_igw.id
    }
  
}


resource "aws_route_table" "vpc_C1_roue_table" {
    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_A
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_A_peering.id
    }
    route {
        cidr_block = var.cidr_vpc_B
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_C_peering.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_C_igw.id
    }
  
}



resource "aws_route_table" "vpc_C4_roue_table" {
    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_A
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_A_peering.id
    }
    route {
        cidr_block = var.cidr_vpc_B
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_C_peering.id
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_C_igw.id
    }
  
}

resource "aws_route_table" "vpc_C2_route_table" {
    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_A
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_A_peering.id
    }
    route {
        cidr_block = var.cidr_vpc_B
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_C_peering.id
    }

    route {
             cidr_block = "0.0.0.0/0"
             nat_gateway_id = aws_nat_gateway.vpc_C_nat_gateway.id

    }

}


resource "aws_route_table" "vpc_C3_route_table" {
    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_A
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_A_peering.id
    }
    route {
        cidr_block = var.cidr_vpc_B
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_C_peering.id
    }
      route {
            cidr_block = "0.0.0.0/0"
             nat_gateway_id = aws_nat_gateway.vpc_C_nat_gateway.id

    }

}

# Associating Route Table with Subnet in VPC A
resource "aws_route_table_association" "vpc_A_subnet_association" {

    subnet_id = aws_subnet.subnet_A.id

    route_table_id = aws_route_table.vpc_A_route_table.id


}





resource "aws_route_table_association" "vpc_B" {
    subnet_id = aws_subnet.subnet_vpc_B.id

    route_table_id = aws_route_table.vpc_B.id
  
}



resource "aws_route_table_association" "vpc_C1_roue_table_association" {
    subnet_id = aws_subnet.public1.id

    route_table_id = aws_route_table.vpc_C1_roue_table.id
  
}


resource "aws_route_table_association" "vpc_C4_roue_table_association" {
    subnet_id = aws_subnet.public2.id

    route_table_id = aws_route_table.vpc_C4_roue_table.id
  
}

resource "aws_route_table_association" "vpc_C2_route_table_association" {
    subnet_id = aws_subnet.private1.id

    route_table_id = aws_route_table.vpc_C2_route_table.id
  
}

resource "aws_route_table_association" "vpc_C3_route_table_association" {
    subnet_id = aws_subnet.private2.id

    route_table_id = aws_route_table.vpc_C3_route_table.id
  
}
