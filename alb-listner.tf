# Create ALB Listner - HTTPS
# certificate_arn is your domain name certificate

# use the commented the port, protocol, ssl and certificate this when you have a domain name
#port = 443
  #protocol = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-0-2015-04"
  #certificate_arn   = "arn:aws:acm:eu-west-1:497415687145:certificate/0e604fcd-22b2-4b18-a284-882b082b37d5"


resource "aws_lb_listener" "dfsc_https" {
  load_balancer_arn = aws_lb.dfsc_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.dfsc-front-end-tg.arn
  }
}

# Create ALB Listner Backend Rule - HTTPS

resource "aws_lb_listener_rule" "dfsc_admin_https" {
  listener_arn = aws_lb_listener.dfsc_https.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dfsc-back-end-tg.arn
  }
    condition {
    path_pattern {
      values = ["/admin*"]
    }
  }
}