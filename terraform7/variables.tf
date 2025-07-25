variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM Role ARN for ECS Task Execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM Role ARN for ECS Task Role"
  type        = string
}

variable "image_uri" {
  description = "Docker image URI for the Strapi container"
  type        = string
}

