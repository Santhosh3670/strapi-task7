resource "aws_cloudwatch_log_group" "strapi" {
  name              = "/ecs/strapi-sk"
  retention_in_days = 7

  tags = {
    Name = "strapi-log-group-sk"
  }
}

