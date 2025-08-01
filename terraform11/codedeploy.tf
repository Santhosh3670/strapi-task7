resource "aws_codedeploy_app" "strapi" {
  name = "strapi-codedeploy-sk"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "strapi" {
  app_name              = aws_codedeploy_app.strapi.name
  deployment_group_name = "strapi-deployment-group-sk"
  service_role_arn      = var.codedeploy_role_arn

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi_cluster.name
    service_name = aws_ecs_service.strapi_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.strapi_listener.arn]
      }

      target_group {
        name = aws_lb_target_group.strapi_blue_tg.name
      }

      target_group {
        name = aws_lb_target_group.strapi_green_tg.name
      }
    }
  }

  depends_on = [
    aws_lb_target_group.strapi_blue_tg,
    aws_lb_target_group.strapi_green_tg,
    aws_lb_listener.strapi_listener
  ]
}

