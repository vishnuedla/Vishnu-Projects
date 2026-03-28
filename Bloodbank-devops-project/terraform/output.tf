output "display_public_ip_of_VPC_B_instance" {
  value = aws_instance.Jump_Box.public_ip
}

output "display_private_ip_of_VPC_C_instance" {
  value = aws_instance.vpc_C_instance

}
