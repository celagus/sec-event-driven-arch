resource "aws_dynamodb_table" "test_dynamodb" {
  name             = "sec-event-driven-arch"
  hash_key         = "ioc_value"
  range_key        = "queued_date"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "ioc_value"
    type = "S"
  }

  attribute {
    name = "queued_date"
    type = "S"
  }
}