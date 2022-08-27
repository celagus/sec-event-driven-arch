from sqs import *
import datetime
from dynamodb import *
from config import AWS_CONFIG

def event_handler(event, context):
    for record in event['Records']:
        print(record)
        body = json.loads(record['body'])
        severity = body['alert_severity']
        ban_end = datetime.datetime.now() + datetime.timedelta(minutes=AWS_CONFIG['ban_lapse'][severity])
        db_event = {
            "sender": record['attributes']['SenderId'],
            "queued_date": str(datetime.datetime.fromtimestamp(int(str(record['attributes']['SentTimestamp'])[:10])).isoformat()),
            "ioc_type": "ip_address",
            "ioc_value": body['ip_address'],
            "ip_version": body['ip_version'],
            "ban_lapse": AWS_CONFIG['ban_lapse'][severity],
            "ban_date_start": str(datetime.datetime.now().isoformat()),
            "ban_date_end": str(ban_end)
        }
        put_item_dynamodb(db_event)
        del_sqs_msg(record['receiptHandle'])