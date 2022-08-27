import boto3
import json
import logging

from config import AWS_CONFIG


client = boto3.client("sqs", region_name=AWS_CONFIG["aws_region"])

# Delete SQS messages
def del_sqs_msg(handle):
    response = client.delete_message(
        QueueUrl=AWS_CONFIG["sqs_url"], ReceiptHandle=handle
    )
    logging.info(f"*** Deleting handle {handle} ***")
    logging.info(f"*** Response {response} ***")


# Puts events on queue
def put_sqs_msg(msgs):
    sqs = boto3.resource("sqs", region_name="us-east-1")
    queue = sqs.get_queue_by_name(QueueName=AWS_CONFIG["sqs_name"])
    for msg in msgs:
        response = queue.send_message(
            MessageBody=json.dumps(msg), MessageGroupId="test"
        )
        logging.info(response.get("MessageId"))
        logging.info(response.get("MD5OfMessageBody"))
