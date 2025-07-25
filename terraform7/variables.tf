variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
}

variable "ecr_repo_name" {
  type        = string
  default     = "strapi-sk"
  description = "ECR repository name"
}

variable "image_uri" {
  type        = string
  description = "Docker image URI"
}

variable "execution_role_arn" {
  type        = string
  description = "IAM Role ARN for ECS Task Execution"
}

variable "task_role_arn" {
  type        = string
  description = "IAM Role ARN for ECS Task Role"
}

