

output "ec2ipaddress" {

    value = aws_instance.Jump_Box.id
}