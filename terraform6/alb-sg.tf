resource "aws_security_group" "alb_sg_sk" {
  name        = "alb-sg-sk"
  description = "Allow HTTP access to ALB"
  vpc_id      = aws_vpc.main_sk.id

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
    Name = "alb-sg-sk"
  }
}

resource "aws_security_group" "ecs_service_sg_sk" {
  name        = "ecs-service-sg-sk"
  description = "Allow traffic from ALB to ECS"
  vpc_id      = aws_vpc.main_sk.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_sk.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg-sk"
  }
}
