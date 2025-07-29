resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "strapi-cpu-alarm-sk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Strapi ECS CPU usage too high"

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "strapi-memory-alarm-sk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Strapi ECS memory usage too high"

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = aws_ecs_service.strapi_service.name
  }
}

resource "aws_cloudwatch_dashboard" "strapi_dashboard" {
  dashboard_name = "strapi-dashboard-sk"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", "strapi-cluster-sk", "ServiceName", "strapi-service-sk" ]
          ],
          period = 60,
          stat   = "Average",
          region = "us-east-2",
          title  = "ECS CPU Utilization"
        }
      },
      {
        type = "metric",
        x    = 12,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", "strapi-cluster-sk", "ServiceName", "strapi-service-sk" ]
          ],
          period = 60,
          stat   = "Average",
          region = "us-east-2",
          title  = "ECS Memory Utilization"
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ECS", "RunningTaskCount", "ClusterName", "strapi-cluster-sk", "ServiceName", "strapi-service-sk" ]
          ],
          period = 60,
          stat   = "Average",
          region = "us-east-2",
          title  = "Running Task Count"
        }
      },
      {
          "type": "metric",
          "x": 12,
          "y": 6,
          "width": 12,
          "height": 6,
          "properties": {
          "metrics": [
            [ "ECS/ContainerInsights", "NetworkRxBytes", "ClusterName", "strapi-cluster-sk", "ServiceName", "strapi-service-sk" ]
            ],
          "period": 60,
          "stat": "Sum",
          "region": "us-east-2",
          "title": "Network In (Bytes)"
            }
        },
        {
           "type": "metric",
           "x": 0,
           "y": 12,
           "width": 12,
           "height": 6,
           "properties": {
           "metrics": [
              [ "ECS/ContainerInsights", "NetworkTxBytes", "ClusterName", "strapi-cluster-sk", "ServiceName", "strapi-service-sk" ]
             ],
           "period": 60,
           "stat": "Sum",
           "region": "us-east-2",
           "title": "Network Out (Bytes)"
         }
       }

    ]
  })
}

