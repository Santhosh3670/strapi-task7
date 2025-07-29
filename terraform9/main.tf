provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "strapi_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "strapi-vpc-sk"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.strapi_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.strapi_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "subnet-b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.strapi_vpc.id

  tags = {
    Name = "strapi-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.strapi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "strapi-public-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-sk"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.strapi_vpc.id

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
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Name = "strapi-alb-sk"
  }
}

resource "aws_lb_target_group" "strapi_tg" {
  name        = "strapi-tg-sk"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.strapi_vpc.id
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
    Name = "strapi-tg-sk"
  }
}

resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
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

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  network_configuration {
    subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.strapi_task,
    aws_lb_listener.strapi_listener
  ]
}

