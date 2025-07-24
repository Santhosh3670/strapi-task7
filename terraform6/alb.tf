resource "aws_lb" "strapi_alb_sk" {
  name               = "strapi-alb-sk"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_sk.id, aws_subnet.public_subnet_2_sk.id]
  security_groups    = [aws_security_group.alb_sg_sk.id]

  tags = {
    Name = "strapi-alb-sk"
  }
}

resource "aws_lb_target_group" "strapi_tg_sk" {
  name     = "strapi-tg-sk"
  port     = 1337
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.main_sk.id

  health_check {
    path                = "/_health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "strapi-tg-sk"
  }
}

resource "aws_lb_listener" "strapi_listener_sk" {
  load_balancer_arn = aws_lb.strapi_alb_sk.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg_sk.arn
  }
}
