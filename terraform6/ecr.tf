provider "aws" {
  region = "us-east-2"
}

resource "aws_ecr_repository" "strapi" {
  name                 = "strapi-app-sk"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

