# CREATE EFS SECURITY GROUP

resource "aws_security_group" "dfsc_efs_sg" {
  name = "DFSC EFS Security Group"
  vpc_id = aws_vpc.dfsc_vpc.id
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    security_groups = [aws_security_group.dfsc_asg_sg.id]
  }
  tags = {
    Name        = "EFS Security Group"
    Terraform   = "true"
  }
}

# CREATE ELASTIC FILE SYSTEM

resource "aws_efs_file_system" "dfsc_efs" {
  creation_token = "dfsc-elastic-file-system" 
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  tags = {
    Name        = "DFSC Elastic File System"
    Terraform   = "true"
  }
}

# CREATE ELASTIC FILE SYSTEM MOUNT TARGETS

resource "aws_efs_mount_target" "dfsc-mount-priavte-2a" {
  file_system_id = aws_efs_file_system.dfsc_efs.id
  subnet_id      = aws_subnet.dfsc-private-2a.id
  security_groups = [
    aws_security_group.dfsc_efs_sg.id
  ]
}
resource "aws_efs_mount_target" "dfsc-mount-priavte-2b" {
  file_system_id = aws_efs_file_system.dfsc_efs.id
  subnet_id      = aws_subnet.dfsc-private-2b.id
  security_groups = [
    aws_security_group.dfsc_efs_sg.id
  ]
}