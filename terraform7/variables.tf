variable "aws_region" {
  default = "us-east-2"
}

variable "image_uri" {
  description = "Full image URI with tag"
}

variable "execution_role_name" {
  default = "ecs-task-execution-role"
}

variable "task_role_name" {
  default = "ecs-task-execution-role"
}

