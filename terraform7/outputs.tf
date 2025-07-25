output "alb_url" {
  value       = "http://${aws_lb.strapi_alb.dns_name}"
  description = "Public ALB URL to access the Strapi app"
}

