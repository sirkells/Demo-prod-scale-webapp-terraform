# Create Domain Record for the website - ALB

resource "aws_route53_record" "www-record" {
  zone_id = "Z0306500593NFEEY7WFD"
  name    = "www.demofitnessshop.com"
  type    = "A"
  alias {
    name                   = aws_lb.dfsc_alb.dns_name
    zone_id                = aws_lb.dfsc_alb.zone_id
    evaluate_target_health = false
  }
}

# Create Domain Record for CDN

resource "aws_route53_record" "cdn-record" {
  zone_id = "Z0306500593NFEEY7WFD"
  name    = "cdn.demofitnessshop.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.dfsc_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.dfsc_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}