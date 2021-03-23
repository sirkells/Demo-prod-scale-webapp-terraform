# Create Bastion Host Security Group

resource "aws_security_group" "dfsc_bastion_sg" {
  vpc_id = aws_vpc.dfsc_vpc.id
  name = "Bastion Host Security Group"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "DFSC Bastion Security Group"
    Terraform   = "true"
    } 
}

# CREATE TEMPLATE FILE DATA SOURCE

data "template_file" "db_import_template" {
  template = file("db-user-data.tpl")
  vars = {
    db_host     = aws_db_instance.dfsc-db.address
    db_username = aws_db_instance.dfsc-db.username
    db_name     = aws_db_instance.dfsc-db.name
    db_password = var.db-master-password
  }
}

# CREATE BASTION HOST IN EU-WEST-2A PUBLIC SUBNET

resource "aws_instance" "dfsc_bastion_host-2a" {
  ami = "ami-05b622b5fa0269787"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.dfsc_bastion_sg.id]
  subnet_id = aws_subnet.dfsc-public-2a.id
  iam_instance_profile          = aws_iam_instance_profile.bastion_host_profile.id
  user_data                     = data.template_file.db_import_template.rendered
  tags = {
    Name = "DFSC Bastion Host - 2A"
    Terraform = true
  }
}

# CREATE BASTION HOST IN EU-WEST-2B PUBLIC SUBNET

resource "aws_instance" "dfsc_bastion_host-2b" {
  ami = "ami-05b622b5fa0269787"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.dfsc_bastion_sg.id]
  subnet_id = aws_subnet.dfsc-public-2b.id
  tags = {
    Name = "DFSC Bastion Host - 2B"
    Terraform = true
  }
}