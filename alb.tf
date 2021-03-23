# Create Application Load Balancer Security Group

resource "aws_security_group" "dfsc_alb_sg" {
  vpc_id = aws_vpc.dfsc_vpc.id
  name = "ALB Security Group"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "DFSC ALB Security Group"
    Terraform   = "True"   
  } 
}

# Create Application Load Balancer

resource "aws_lb" "dfsc_alb" {
  name               = "dfsc-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dfsc_alb_sg.id]
  subnets = [
    aws_subnet.dfsc-public-2a.id,
    aws_subnet.dfsc-public-2b.id,
  ]
  enable_deletion_protection = false
  tags = {
    Name        = "DFSC Application Load Balancer"
    Terraform   = "True"   
  } 
}