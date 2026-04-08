

resource "aws_internet_gateway" "vpc_A_igw" {

    vpc_id = aws_vpc.vpc_A.id
  
}


resource "aws_internet_gateway" "vpc_B_igw" {

    vpc_id = aws_vpc.B.id
  
}


resource "aws_internet_gateway" "vpc_C_igw" {
    vpc_id = aws_vpc.vpc_C.id
  
}




#Peering connection between VPC A and VPC B

resource "aws_vpc_peering_connection" "vpc_B_A_peering" {
    vpc_id = aws_vpc.B.id
    peer_vpc_id = aws_vpc.vpc_A.id
    auto_accept = true
}

#Peering connection between VPC B and VPC C

resource "aws_vpc_peering_connection" "vpc_B_C_peering" {
    vpc_id = aws_vpc.B.id
    peer_vpc_id = aws_vpc.vpc_C.id
    auto_accept = true
}

#Peering connection between VPC A and VPC C

resource "aws_vpc_peering_connection" "vpc_C_A_peering" {
    vpc_id = aws_vpc.vpc_C.id
    peer_vpc_id = aws_vpc.vpc_A.id
    auto_accept = true
}
