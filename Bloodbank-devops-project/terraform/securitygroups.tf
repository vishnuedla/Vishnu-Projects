##Security Groups

# Cluster SG (attached to EKS control plane ENIs)

resource "aws_security_group" "vpc_c_sg" {
  
    name = "vpc_c_sg"

    description = "Security Group for VPC C"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
       cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

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
        cidr_blocks = ["49.204.3.192/32"]

    }
    
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["49.204.3.192/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}



resource"aws_security_group" "ecr_sg" {
    name = "ecr_sg"

    description = "Security Group for ECR"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.3.0/24"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "secretsmanager_sg" {
    name = "secretsmanager_sg"

    description = "Security Group for Secrets Manager"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.3.0/24"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}
resource "aws_security_group" "efs_sg" {
    name = "efs_sg"

    description = "Security Group for EFS"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 2049
        to_port = 2049
        protocol = "tcp"
        cidr_blocks = ["10.0.3.0/24"]
    }

     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}


resource "aws_security_group" "sts_sg" {
    name = "sts_sg"

    description = "Security Group for STS"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.3.0/24"]
    }
     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}
resource "aws_security_group" "logs_sg" {
    name = "logs_sg"

    description = "Security Group for CloudWatch Logs"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.0.3.0/24"]
    }
     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
}
}