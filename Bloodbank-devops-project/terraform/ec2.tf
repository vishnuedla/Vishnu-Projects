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
                sudo apt-get install -y ca-certificates curl gnupg lsb-release
                sudo mkdir -p /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg |   sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                echo   "deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update -y
                sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                sudo usermod -aG docker ubuntu
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

  
