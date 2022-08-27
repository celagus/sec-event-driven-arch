import boto3

AWS_CONFIG = {
    "sqs_name": "sec-event-driven-arch.fifo",
    "aws_region": "us-east-1",
    "table_name": "sec-event-driven-arch",
    "ip_set_name": "malicious_actors",
    "ban_lapse": dict(critical=43200, high=10080, medium=1440, low=60)
}

sts = boto3.client("sts")
AWS_CONFIG["sqs_url"] = f"https://sqs.us-east-1.amazonaws.com/{sts.get_caller_identity()['Account']}/{AWS_CONFIG['sqs_name']}"