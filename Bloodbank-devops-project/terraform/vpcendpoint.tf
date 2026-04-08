resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id            = aws_vpc.vpc_C.id
  service_name      = "com.amazonaws.ap-south-1.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids      = [aws_subnet.private1.id,aws_subnet.private2.id]
  security_group_ids = [aws_security_group.vpc_c_sg.id]
  depends_on = [ aws_ecr_repository.bloodbank_ecr_repository ]
}


resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id            = aws_vpc.vpc_C.id
  service_name      = "com.amazonaws.ap-south-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids      = [aws_subnet.private1.id,aws_subnet.private2.id]
  security_group_ids = [aws_security_group.vpc_c_sg.id]
  depends_on = [ aws_ecr_repository.bloodbank_ecr_repository ]
}

resource "aws_vpc_endpoint" "secretsmanager_endpoint" {
  vpc_id            = aws_vpc.vpc_C.id
  service_name      = "com.amazonaws.ap-south-1.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids      = [aws_subnet.private1.id,aws_subnet.private2.id]
  security_group_ids = [aws_security_group.secretsmanager_sg.id]
  
  depends_on = [ aws_secretsmanager_secret.bloodbank_secret ]
}
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.vpc_C.id
  service_name      = "com.amazonaws.ap-south-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [ aws_route_table.vpc_C2_route_table.id, aws_route_table.vpc_C3_route_table.id]
  
}

resource "aws_vpc_endpoint" "sts_endpoint" {
  vpc_id             = aws_vpc.vpc_C.id
  service_name       = "com.amazonaws.ap-south-1.sts"
  vpc_endpoint_type  = "Interface"
  subnet_ids      = [aws_subnet.private1.id,aws_subnet.private2.id]
  security_group_ids = [aws_security_group.sts_sg.id]
}
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.vpc_C.id
  service_name      = "com.amazonaws.ap-south-1.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  security_group_ids = [aws_security_group.logs_sg.id]
    

}