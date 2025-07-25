output "alb_dns_name" {
  description = "Public ALB URL to access Strapi"
  value       = aws_lb.strapi_alb.dns_name
}

