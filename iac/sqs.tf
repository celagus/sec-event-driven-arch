resource "aws_sqs_queue" "test_queue" {
  name                        = "sec-event-driven-arch.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  max_message_size            = 4096
  message_retention_seconds   = 14400
  receive_wait_time_seconds   = 10
  visibility_timeout_seconds  = 150 #must be the same as lambda execution timeout or minor
  sqs_managed_sse_enabled     = true

# Add this block if you want to create a DLQ
#  redrive_policy = jsonencode({
#    deadLetterTargetArn = aws_sqs_queue.test_dlq.arn
#    maxReceiveCount     = 4
#  })
#
#  redrive_allow_policy = jsonencode({
#    redrivePermission = "byQueue",
#    sourceQueueArns   = ["${aws_sqs_queue.test_dlq.arn}"]
#  })
}

# Add this block if you want to create a DLQ for missed events
#resource "aws_sqs_queue" "test_dlq" {
#  name                       = "sec-event-driven-arch.fifo_dlq.fifo"
#  sqs_managed_sse_enabled    = true
#  fifo_queue                 = true
#  max_message_size           = 4096
#  message_retention_seconds  = 14400
#  receive_wait_time_seconds  = 10
#  visibility_timeout_seconds = 600
#}