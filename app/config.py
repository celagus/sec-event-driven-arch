AWS_CONFIG = {
    "sqs_url": "<your-sqs-arn-here>",
    "sqs_name": "sec-event-driven-arch.fifo",
    "aws_region": "us-east-1",
    "table_name": "sec-event-driven-arch",
    "ip_set_name": "malicious_actors",
    "ban_lapse": dict(critical=43200, high=10080, medium=1440, low=60)
}