output "alb_dns_name" {
  description = "Public URL to access Strapi"
  value       = aws_lb.strapi_alb_sk.dns_name
}
