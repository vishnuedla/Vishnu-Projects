provider "aws" {
  
  region = "ap-south-1"

}

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



resource "aws_subnet" "vpc_C_subnet" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id    = data.aws_availability_zones.available.zone_ids[0]
    cidr_block = var.subnet_cidr_vpc_c1
    tags = {
        Name = "vpc_C_subnet1"
    }
}

resource "aws_subnet" "vpc_C_subnet2" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id = data.aws_availability_zones.available.zone_ids[1]
    map_public_ip_on_launch = false
    cidr_block = var.subnet_cidr_vpc_c2
    tags = {
        Name = "vpc_C_subnet2"
    }
}

resource "aws_subnet" "vpc_C_subnet3" {
    vpc_id = aws_vpc.vpc_C.id
    availability_zone_id = data.aws_availability_zones.available.zone_ids[2]
    cidr_block = var.subnet_cidr_vpc_c3
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc_C_subnet3"
    }
}

###internet gatewayS

# Creating Internet Gateway

resource "aws_internet_gateway" "vpc_A_igw" {

    vpc_id = aws_vpc.vpc_A.id
  
}


resource "aws_internet_gateway" "vpc_B_igw" {

    vpc_id = aws_vpc.B.id
  
}


resource "aws_internet_gateway" "vpc_C_igw" {
    vpc_id = aws_vpc.vpc_C.id
  
}


#NAT Gateway for VPC A

resource "aws_eip" "nat_eip" {

}


resource "aws_nat_gateway" "vpc_C_nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.vpc_C_subnet.id
    tags = {
        Name = "vpc_C_nat_gateway"
    }
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
    subnet_id = aws_subnet.vpc_C_subnet.id

    route_table_id = aws_route_table.vpc_C1_roue_table.id
  
}

resource "aws_route_table_association" "vpc_C2_route_table_association" {
    subnet_id = aws_subnet.vpc_C_subnet2.id

    route_table_id = aws_route_table.vpc_C2_route_table.id
  
}

resource "aws_route_table_association" "vpc_C3_route_table_association" {
    subnet_id = aws_subnet.vpc_C_subnet3.id

    route_table_id = aws_route_table.vpc_C3_route_table.id
  
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
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}


resource "aws_security_group" "vpc_c" {
    name = "vpc_C_sg"

    description = "Security Group for VPC C"

    vpc_id = aws_vpc.vpc_C.id

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
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

     user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
                echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
                sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
                chmod +x kubectl
                mkdir -p ~/.local/bin
                mv ./kubectl ~/.local/bin/kubectl
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                sudo apt-get install unzip -y
                unzip awscliv2.zip
                sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
                sudo apt-get install -y git
                git clone https://github.com/vishnuedla/Vishnu-Projects.git
            EOF

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

 version  = "1.35"

  vpc_config {
    subnet_ids = [aws_subnet.vpc_C_subnet.id, aws_subnet.vpc_C_subnet2.id, aws_subnet.vpc_C_subnet3.id]
     security_group_ids = [aws_security_group.vpc_c.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
  
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

resource "aws_iam_role_policy_attachment" "efspolicy" {
  role   = aws_iam_role.eks_nodegroup_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess" 
}

resource "aws_eks_node_group" "bloodbank_nodegroup" {
  cluster_name    = aws_eks_cluster.bloodbank_eks_cluster.name
  node_group_name = "bloodbank-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [aws_subnet.vpc_C_subnet2.id, aws_subnet.vpc_C_subnet3.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["m7i-flex.large"]

  tags = {
    Name = "bloodbank-nodegroup"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_nodegroup_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_policy,
    aws_iam_role_policy_attachment.efspolicy
  ]

}



resource "aws_ecr_repository" "bloodbank_ecr_repository" {
  name = "bloodbank-ecr-repository"
  
  image_scanning_configuration {
    scan_on_push = true
  }

}










































