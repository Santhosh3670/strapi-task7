output "alb_dns_name" {
  description = "Public ALB URL to access Strapi"
  value       = aws_lb.strapi_alb.dns_name
}
output "log_group_name" {
  description = "CloudWatch Log Group for ECS logs"
  value       = aws_cloudwatch_log_group.strapi_log_group.name
}

