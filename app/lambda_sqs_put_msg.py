from sqs import put_sqs_msg

def event_handler(event, context):
    msgs = []
    msgs.append(event)
    put_sqs_msg(msgs)