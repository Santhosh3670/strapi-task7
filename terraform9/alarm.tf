resource "aws_sns_topic" "alarm_notifications" {
  name = "strapi-alarms-topic-sk"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = "santhoshkumar.sathy2216@gmail.com"

}

