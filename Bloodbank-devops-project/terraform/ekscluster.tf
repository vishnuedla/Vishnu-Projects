

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
    subnet_ids =  [aws_subnet.public1.id , aws_subnet.public2.id]
    security_group_ids = [aws_security_group.vpc_c_sg.id]
     
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
  subnet_ids      = [aws_subnet.private1.id,aws_subnet.private2.id]

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




















































