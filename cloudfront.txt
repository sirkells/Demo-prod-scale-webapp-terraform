# CREATE CLOUDFRONT DISTRIBUTION

locals {
  dfsc_origin_id = "dfsc-origin"
}
resource "aws_cloudfront_distribution" "dfsc_distribution" {
  origin {
    domain_name = aws_lb.dfsc_alb.dns_name
    origin_id   = local.dfsc_origin_id
    custom_origin_config {
    http_port = "80"
    https_port = "443"
    origin_protocol_policy = "https-only"
    origin_ssl_protocols = ["TLSv1"]
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "dfsc-cloudfront-distribution"
  aliases = ["cdn.demofitnessshop.com"]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.dfsc_origin_id
    forwarded_values {
      query_string = false
      headers = ["host","origin","Access-Control-Request-Headers","Access-Control-Request-Method"]
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_All"
  restrictions {
   geo_restriction {
     restriction_type = "none"
   }
 }
  viewer_certificate {
    cloudfront_default_certificate = false
    ssl_support_method = "sni-only"
    acm_certificate_arn = "arn:aws:acm:us-east-1:497415687145:certificate/115b7c55-8f0f-4aa3-9579-c578b4aa845c"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}