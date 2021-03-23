# Create Frontend Target Group

resource "aws_lb_target_group" "dfsc-front-end-tg" {
  port = 80
  protocol = "HTTP"
  name = "dfsc-front-end-target-group"
  vpc_id = aws_vpc.dfsc_vpc.id
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
  health_check {
    protocol = "HTTP"
    path = "/healthy.html"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
  }
  tags = {
    Name        = "DFSC Front End Target Group"
    Terraform   = "True"   
  } 
}

# Create Backend Target Group


resource "aws_lb_target_group" "dfsc-back-end-tg" {
  port = 80
  protocol = "HTTP"
  name = "dfsc-back-end-target-group"
  vpc_id = aws_vpc.dfsc_vpc.id
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
  health_check {
    protocol = "HTTP"
    path = "/healthy.html"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
  }
  tags = {
    Name        = "DFSC Back End Target Group"
    Terraform   = "True"   
  } 
}