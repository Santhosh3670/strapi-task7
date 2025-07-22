variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region"
}
