variable "aws_region" {
  default = "us-east-2"
}

variable "image_uri" {
  description = "Full image URI with tag"
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "ECS task role ARN"
  type        = string
}
