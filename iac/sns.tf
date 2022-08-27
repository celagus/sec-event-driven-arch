# you must configure your SNS topic regarding your own environment
resource "aws_sns_topic" "test_topic" {
  name                        = "test_topic"
  fifo_topic                  = false
}
