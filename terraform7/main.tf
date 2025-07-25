provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster-sk"
}

resource "aws_ecr_repository" "strapi_repo" {
  name = "strapi-sk"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "strapi-vpc-sk"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "strapi-subnet-sk"
  }
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-sk"
  description = "Allow HTTP and HTTPS"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg-sk"
  }
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task-sk"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.image_uri
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service-sk"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.public_subnet.id]
    security_groups = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.strapi_task
  ]
}

