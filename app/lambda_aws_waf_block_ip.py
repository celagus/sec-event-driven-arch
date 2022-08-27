import boto3
from config import AWS_CONFIG
import json
import datetime

class WAFUpdateError(Exception):
    pass

client = boto3.client('wafv2', region_name=AWS_CONFIG['aws_region'])

def get_ip_set():
    response = client.list_ip_sets(
        Scope='CLOUDFRONT'
    )
    target = {}
    for ip_set in response['IPSets']:
        if ip_set['Name'] == AWS_CONFIG['ip_set_name']:
            target = {
                "id": ip_set['Id'],
                "lock_token": ip_set['LockToken']
            }
    return target

def update_ip_set(event: dict, target: dict) -> dict:
    raw = client.get_ip_set(
        Name=AWS_CONFIG['ip_set_name'],
        Scope='CLOUDFRONT',
        Id=target['id']
    )
    addresses = raw['IPSet']['Addresses']
    if int(event['ip_version']) == 4:
        addresses.append(f"{event['ip_address']}/32")
    else:
        addresses.append(f"{event['ip_address']}/128")
    response = client.update_ip_set(
        Name=AWS_CONFIG['ip_set_name'],
        Scope='CLOUDFRONT',
        Id=target['id'],
        Description=f'updated by automatic workflow at {str(datetime.datetime.now().isoformat())}',
        Addresses=addresses,
        LockToken=target['lock_token']
    )
    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
        return response
    else:
        raise WAFUpdateError(response)

def event_handler(event, context):
    target = get_ip_set()
    event['step_block_aws_waf'] = json.dumps(update_ip_set(event, target))
    return event