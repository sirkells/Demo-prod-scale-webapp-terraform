# CREATE FRONTEND AUTOSCALING POLICY

resource "aws_autoscaling_policy" "dfsc-frontend-asg-policy" {
  name                   = "frontend-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.dfsc_front_end.name
  target_tracking_configuration {
   predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }
    target_value = 40.0
  }  
}

# CREATE BACKEND AUTOSCALING POLICY

resource "aws_autoscaling_policy" "dfsc-backend-asg-policy" {
  name                   = "backend-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.dfsc_back_end.name
  target_tracking_configuration {
   predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }
    target_value = 40.0
  }  
}