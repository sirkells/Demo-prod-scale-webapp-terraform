# CREATE RDS SECURITY GROUP

resource "aws_security_group" "dfsc_db_sg" {
  name = "DFSC RDS Security Group"
  vpc_id = aws_vpc.dfsc_vpc.id
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      aws_security_group.dfsc_asg_sg.id,
      aws_security_group.dfsc_bastion_sg.id
    ]
  }
  tags = {
    Name        = "RDS Security Group"
    Terraform   = "true"
  }
}

# Create DFSC Database Subnet Group

resource "aws_db_subnet_group" "dfsc-db-subnet" {
  name = "dfsc-database-subnet-group"
  subnet_ids = [
    aws_subnet.dfsc-private-2a.id,
    aws_subnet.dfsc-private-2b.id
    ]

  tags = {
    Name        = "DB Subnet Group"
    Terraform   = "true"
  }
}

# Create DFSC Database Instance 

resource "aws_db_instance" "dfsc-db" {
  allocated_storage       = "10"
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.6"
  multi_az                = "true"
  instance_class          = "db.t2.micro"
  name                    = "magento"
  username                = "admin"
  password                = var.db-master-password
  identifier              = "dfsc-database"
  skip_final_snapshot     = "true"
  backup_retention_period = "7"
  port                    = "3306"
  storage_encrypted       = "false"
  db_subnet_group_name    = aws_db_subnet_group.dfsc-db-subnet.name
  vpc_security_group_ids  = [aws_security_group.dfsc_db_sg.id]
   tags = {
    Name        = "DFSC Database"
    Terraform   = "true"
  }
}