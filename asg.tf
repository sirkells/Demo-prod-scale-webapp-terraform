# Create Security Group for ASG

resource "aws_security_group" "dfsc_asg_sg" {
  vpc_id = aws_vpc.dfsc_vpc.id
  name = "ASG Security Group"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
 ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [
      aws_security_group.dfsc_alb_sg.id
    ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.dfsc_bastion_sg.id
    ]
  }
  tags = {
    Name        = "DFSC ASG Security Group"
    Terraform   = "true"
  } 
}

# Template File Data Source
 
data "template_file" "userdata_template" {
  template = file("user-data.tpl")
  vars = {
    db_host         = aws_db_instance.dfsc-db.address
    db_username     = aws_db_instance.dfsc-db.username
    db_password     = var.db-master-password
    db_name         = aws_db_instance.dfsc-db.name
    cache_host      = aws_elasticache_replication_group.dfsc_elasticache.primary_endpoint_address
    efs-endpoint    = aws_efs_file_system.dfsc_efs.dns_name
  }
}


# Create Launch Configuration

resource "aws_launch_configuration" "dfsc_launch_config" {
  name_prefix   = "DFSC Launch Configuration"
  image_id      = "ami-09100ee7e220c8ace"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.dfsc_asg_sg.id]
  key_name = aws_key_pair.ssh-key.key_name
  user_data       = data.template_file.userdata_template.rendered
  lifecycle {
    create_before_destroy = true
  }
}

# Create DFSC FrontEnd ASG

resource "aws_autoscaling_group" "dfsc_front_end" {
  name                 = "DFSC FrontEnd ASG"
  launch_configuration = aws_launch_configuration.dfsc_launch_config.name
  health_check_type    = "ELB"
  min_size             = 2
  max_size             = 6
  desired_capacity     = 2

  vpc_zone_identifier = [
    aws_subnet.dfsc-private-2a.id,
    aws_subnet.dfsc-private-2b.id
  ]
  target_group_arns = [aws_lb_target_group.dfsc-front-end-tg.arn]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "DFSC FrontEnd ASG"
    propagate_at_launch = true  
  }
}

# Create DFSC Backend ASG

resource "aws_autoscaling_group" "dfsc_back_end" {
  name                 = "DFSC BackEnd ASG"
  launch_configuration = aws_launch_configuration.dfsc_launch_config.name
  health_check_type    = "ELB"
  min_size             = 2
  max_size             = 6
  desired_capacity     = 2

  vpc_zone_identifier = [
    aws_subnet.dfsc-private-2a.id,
    aws_subnet.dfsc-private-2b.id
  ]
  target_group_arns = [aws_lb_target_group.dfsc-back-end-tg.arn]
  lifecycle {
    create_before_destroy = true
  }
 tag {
    key                 = "Name"
    value               = "DFSC BackEnd ASG"
    propagate_at_launch = true  
  }
}