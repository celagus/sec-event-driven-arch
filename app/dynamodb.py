import boto3
import logging

from config import *


dynamodb = boto3.resource("dynamodb", region_name=AWS_CONFIG["aws_region"])
table = dynamodb.Table(AWS_CONFIG["table_name"])


def put_item_dynamodb(msg: dict) -> dict:
    response = table.put_item(Item=msg)
    logging.info(f"*** Puting item punisher db ***")
    logging.info(response)
    return response
