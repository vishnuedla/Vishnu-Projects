
#NAT Gateway for VPC A

resource "aws_eip" "nat_eip" {

}


resource "aws_nat_gateway" "vpc_C_nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public1.id
    tags = {
        Name = "vpc_C_nat_gateway"
    }
}

