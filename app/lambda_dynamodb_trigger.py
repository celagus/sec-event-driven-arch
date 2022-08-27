import boto3
import json
from config import AWS_CONFIG

client = boto3.client('lambda', region_name=AWS_CONFIG["aws_region"])

def invoke_fn(event, name):
    response = client.invoke(
        FunctionName=name,
        InvocationType='Event',
        ClientContext='',
        Payload=json.dumps(event)
    )
    return response

def event_handler(event, context):
    for record in event['Records']:
        if record['eventName'] == "INSERT" and record['dynamodb']['NewImage']['ioc_type']['S'] == "ip_address":
            payload = {
                "ip_address": record['dynamodb']['NewImage']['ioc_value']['S'],
                "ip_version": record['dynamodb']['NewImage']['ip_version']['N']
            }
            invoke_fn(payload, "lambda_aws_waf_block_ip")
        elif record['eventName'] == "REMOVE" and record['dynamodb']['OldImage']['ioc_type']['S'] == "ip_address":
            payload = {
                "ip_address": record['dynamodb']['OldImage']['ioc_value']['S'],
                "ip_version": record['dynamodb']['OldImage']['ip_version']['N']
            }
            invoke_fn(payload, "lambda_aws_waf_unblock_ip")
