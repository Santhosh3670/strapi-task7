variable "aws_region" {
  default = "us-east-2"
}

variable "image_uri" {
  description = "The image URI for the Strapi container"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN that ECS tasks use to pull images and publish logs"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN that the task assumes"
  type        = string
}

variable "codedeploy_role_arn" {
  description = "IAM role ARN for CodeDeploy to perform ECS actions"
  type        = string
}

