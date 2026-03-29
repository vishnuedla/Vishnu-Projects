

output "efs-volume" {
  value = aws_efs_file_system.bloodbank_efs.id
}