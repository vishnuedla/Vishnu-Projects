

resource "aws_ecr_repository" "bloodbank_ecr_repository" {
  name = "bloodbank-ecr-repository"
  
  image_scanning_configuration {
    scan_on_push = true
  }

}


resource "aws_efs_file_system" "bloodbank_efs" {
  creation_token = "BloodbankEFS"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "bloodbank_efs"
  }
}



resource "aws_efs_mount_target" "target1" {
  file_system_id = aws_efs_file_system.bloodbank_efs.id
  subnet_id      =  aws_subnet.private1.id

  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "target2" {
  file_system_id = aws_efs_file_system.bloodbank_efs.id
  subnet_id      = aws_subnet.private2.id

  security_groups = [aws_security_group.efs_sg.id]
}
resource "aws_secretsmanager_secret" "bloodbank_secret" {
  name = "bloodbank-secret12"
  description = "Secret for Bloodbank application" 

}