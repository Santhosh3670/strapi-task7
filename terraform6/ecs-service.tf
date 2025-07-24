resource "aws_ecs_service" "strapi_service_sk" {
  name            = "strapi-service-sk"
  cluster         = aws_ecs_cluster.strapi_cluster_sk.id
  task_definition = aws_ecs_task_definition.strapi_task_sk.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [
      aws_subnet.public_subnet_sk.id,
      aws_subnet.public_subnet_2_sk.id
    ]
    security_groups = [aws_security_group.ecs_service_sg_sk.id]
    assign_public_ip = true  # ✅ Required for ECR access
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg_sk.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.strapi_listener_sk]
}
