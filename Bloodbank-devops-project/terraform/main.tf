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


 #Creating VPC C
resource "aws_vpc" "vpc_C" {


    cidr_block = var.cidr_vpc_c
  
}

# Creating Subnet for VPC C
resource "aws_subnet" "vpc_C_subnet" {

    vpc_id = aws_vpc.vpc_C.id

    cidr_block = var.subnet_cidr_vpc_c
    
    availability_zone = "ap-south-1a"
  
}
#subnet 2 for vpc c
resource "aws_subnet" "vpc_C_subnet2" {

    vpc_id = aws_vpc.vpc_C.id

    cidr_block = var.subnet_cidr_vpc_c2

    availability_zone = "ap-south-1b"

}



#creating vpc D and subnet for vpc D

resource "aws_vpc" "vpc_D" {


    cidr_block = var.cidr_vpc_D
  
}

resource "aws_subnet" "vpc_D_subnet" {

    vpc_id = aws_vpc.vpc_D.id

    cidr_block = var.subnet_cidr_vpc_D
  
}


###internet gatewayS

# Creating Internet Gateway for VPC B
resource "aws_internet_gateway" "vpc_B_igw" {

    vpc_id = aws_vpc.B.id
  
}


# Creating Internet Gateway for VPC C

resource "aws_internet_gateway" "vpc_C_igw" {

    vpc_id = aws_vpc.vpc_C.id
  
}

#Routes tables for above vpc

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
    route {
        cidr_block = var.cidr_vpc_D
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_D_peering.id

    }

}

# Associating Route Table with Subnet in VPC B
resource "aws_route_table_association" "vpc_B_subnet_association" {

    subnet_id = aws_subnet.subnet_vpc_B.id

    route_table_id = aws_route_table.vpc_B_route_table.id

}

#Route table for VPC C


resource "aws_route_table" "vpc_C_route_table2" {

    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_D
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_D_peering.id
    }


}


resource "aws_route_table_association" "vpc_C_subnet_association2" {

    subnet_id = aws_subnet.vpc_C_subnet2.id

    route_table_id = aws_route_table.vpc_C_route_table2.id

}

resource "aws_route_table" "vpc_C_route_table" {

    vpc_id = aws_vpc.vpc_C.id

    route {
        cidr_block = var.cidr_vpc_D
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_D_peering.id
    }


}

#Associating Route Table with Subnet in VPC C

resource "aws_route_table_association" "vpc_C_subnet_association" {

    subnet_id = aws_subnet.vpc_C_subnet.id

    route_table_id = aws_route_table.vpc_C_route_table.id

}





resource "aws_route_table" "vpc_D_route_table" {

    vpc_id = aws_vpc.vpc_D.id

    route {
        cidr_block = var.cidr_vpc_c
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_C_D_peering.id
    }
    route {
        cidr_block = var.cidr_vpc
        vpc_peering_connection_id = aws_vpc_peering_connection.vpc_B_D_peering.id
    }
  
}

#PEERING CONNECTIONS 
#peering connection between VPC B and VPC C
resource "aws_vpc_peering_connection" "vpc_B_C_peering" {

    vpc_id = aws_vpc.B.id

    peer_vpc_id = aws_vpc.vpc_C.id

    auto_accept = true
  
}

#peering connection between VPC C and VPC D
resource "aws_vpc_peering_connection" "vpc_C_D_peering" {

    vpc_id = aws_vpc.vpc_C.id

    peer_vpc_id = aws_vpc.vpc_D.id

    auto_accept = true
  
}

##peering connection between VPC B and VPC D
resource "aws_vpc_peering_connection" "vpc_B_D_peering" {

    vpc_id = aws_vpc.B.id

    peer_vpc_id = aws_vpc.vpc_D.id

    auto_accept = true
  
}




##Security Groups
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


resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS traffic"
  vpc_id      = aws_vpc.vpc_D.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_C.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#resources
## key pair for instanceaction 
  
resource "aws_key_pair" "vpc_B_key" {
    key_name = "bloodbank_key"
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



resource "aws_iam_role" "eks_cluster_bloodbank_role" {
    name = "eks_cluster_role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "eks.amazonaws.com"
            }
        }
        ]
    })


}



resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_bloodbank_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_service" {
  role       = aws_iam_role.eks_cluster_bloodbank_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


## creating eks 
resource "aws_eks_cluster" "bloodbank_eks_cluster" {
  name     = "bloodbank-eks-cluster"
 role_arn = aws_iam_role.eks_cluster_bloodbank_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.vpc_C_subnet.id, aws_subnet.vpc_C_subnet2.id]
  }
  
}


resource "aws_iam_role" "eks_fargate_pod_role_bloodbank" {
  name = "eks-fargate-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_policy" {
  role       = aws_iam_role.eks_fargate_pod_role_bloodbank.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}


resource "aws_iam_role_policy_attachment" "fargate_ecr_pull" {
  role       = aws_iam_role.eks_fargate_pod_role_bloodbank.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "fargate_efs_access" {
  role       = aws_iam_role.eks_fargate_pod_role_bloodbank.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}

resource "aws_iam_role_policy_attachment" "fargate_secrets_manager" {
  role       = aws_iam_role.eks_fargate_pod_role_bloodbank.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_eks_fargate_profile" "default" {
  cluster_name = aws_eks_cluster.bloodbank_eks_cluster.name
  fargate_profile_name   = "bloodbank-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_role_bloodbank.arn

  subnet_ids = [aws_subnet.vpc_C_subnet.id, aws_subnet.vpc_C_subnet2.id]

  selector {
    namespace = "blood-bank"
  }
}



resource "aws_iam_role" "eks_nodegroup_role" {
  name = "eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_nodegroup_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "bloodbank_nodegroup" {
  cluster_name    = aws_eks_cluster.bloodbank_eks_cluster.name
  node_group_name = "bloodbank-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [aws_subnet.vpc_C_subnet.id, aws_subnet.vpc_C_subnet2.id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  tags = {
    Name = "bloodbank-nodegroup"
  }
}


resource "aws_efs_file_system" "bloodbank_efs" {
  creation_token = "bloodbank-efs"
 lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  

  tags = {
    Name = "bloodbank-efs"
  }




}

resource "aws_efs_mount_target" "bloodbank_efs_mount_target" {
  file_system_id  = aws_efs_file_system.bloodbank_efs.id
  security_groups = [aws_security_group.vpc_C_sg.id]
  subnet_id = each.value
   for_each = {
    subnet1= aws_subnet.vpc_C_subnet.id
    Subnet2  = aws_subnet.vpc_C_subnet2.id

}


}



resource "aws_ecr_repository" "bloodbank_ecr_repository" {
  name = "bloodbank-ecr-repository"
   image_scanning_configuration {
    scan_on_push = true
  }

}










































