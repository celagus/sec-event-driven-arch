resource "aws_s3_bucket" "sec-event-driven-arch" {
  bucket = "sec-event-driven-arch"
}

resource "aws_s3_bucket_acl" "sec-event-driven-arch" {
  bucket = aws_s3_bucket.sec-event-driven-arch.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "sec-event-driven-arch" {
  bucket = aws_s3_bucket.sec-event-driven-arch.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket       = aws_s3_bucket.sec-event-driven-arch.id
  key          = "index.html"
  source       = "./index.html"
  etag         = filemd5("./index.html")
  content_type = "text/html; charset=utf-8"
  acl          = "public-read"
}