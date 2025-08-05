provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "a" {
  availability_zone = "us-east-2a"
  default_for_az    = true
}

data "aws_subnet" "b" {
  availability_zone = "us-east-2b"
  default_for_az    = true
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-sk"
  description = "Allow HTTP"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 1337
    to_port     = 1337
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


resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-sk2"
  description = "Allow HTTP"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 1337
    to_port     = 1337
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

resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster-sk"
}

resource "aws_lb" "strapi_alb" {
  name               = "strapi-alb-sk"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.strapi_sg.id]
  subnets = [data.aws_subnet.a.id, data.aws_subnet.b.id]

  tags = {
    Name = "strapi-alb-sk"
  }
}

resource "aws_lb_target_group" "strapi_blue_tg" {
  name        = "strapi-blue-tg-sk"
  port        = 1337
  protocol    = "HTTP"
  vpc_id = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
  path     = "/admin"
  protocol = "HTTP"
  matcher  = "200-499"
  interval = 30
  timeout  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
 }

  tags = {
    Name = "strapi-blue-tg-sk"
  }
}

resource "aws_lb_target_group" "strapi_green_tg" {
  name        = "strapi-green-tg-sk"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/admin"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "strapi-green-tg-sk"
  }
}

resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_blue_tg.arn
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

  container_definitions = jsonencode([{
    name      = "strapi"
    image     = var.image_uri
    essential = true
    portMappings = [{
      containerPort = 1337
      protocol      = "tcp"
    }]
    logConfiguration = {
     logDriver = "awslogs"
     options = {
       awslogs-group         = "/ecs/strapi-sk"
       awslogs-region        = var.aws_region
       awslogs-stream-prefix = "ecs"
     }
   }
    environment = [
       {
         name  = "APP_KEYS"
         value = "myAppKeyA,myAppKeyB"
      },
      {
    name  = "ADMIN_JWT_SECRET"
    value = "GcGBhhDx1QgAbPFhZGgX1w=="
  },
  {
    name  = "API_TOKEN_SALT"
    value = "pJA+moB0PAlAFPigFYsFLw=="
  },
  {
    name  = "TRANSFER_TOKEN_SALT"
    value = "QEL8SHyO25m9I0shlYcWXA=="
  },
  {
    name  = "ENCRYPTION_KEY"
    value = "YaYBJstiUhloceTLBijBAQ=="
  },
  {
    name  = "HOST"
    value = "0.0.0.0"
  },
  {
    name  = "PORT"
    value = "1337"
  }
]
    
    command = ["npm", "run", "start"]
  }])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service-sk"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn 
  desired_count   = 1

 capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

    deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_blue_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }


  network_configuration {
    subnets = [data.aws_subnet.a.id, data.aws_subnet.b.id]
    security_groups = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.strapi_task,
    aws_lb_listener.strapi_listener
  ]
}

