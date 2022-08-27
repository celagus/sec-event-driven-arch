import json
import requests
from ipaddress import IPv4Network, IPv6Network, IPv4Address, IPv6Address

class TrustedIPAddress(Exception):
    pass

def check_google_bot_cidr(source_ip, version):
    prefixes_v4 = []
    prefixes_v6 = []
    print("Getting google bots CIDRS")
    response = requests.get("https://developers.google.com/static/search/apis/ipranges/googlebot.json")
    result = json.loads(response.text)
    for cidr in (result['prefixes']):
        if "ipv6Prefix" in cidr:
            prefixes_v6.append(cidr.get('ipv6Prefix'))
        if "ipv4Prefix" in cidr:
            prefixes_v4.append(cidr.get('ipv4Prefix'))
    if version == 4:
        for prefix in prefixes_v4:
            if IPv4Network(source_ip).subnet_of(IPv4Network(prefix)):
                raise TrustedIPAddress
    elif version == 6:
        for prefix in prefixes_v6:
            if IPv6Network(source_ip).subnet_of(IPv6Network(prefix)):
                raise TrustedIPAddress
    print("All good, no coincidence!")


def event_handler(event, context):
    check_google_bot_cidr(event["ip_address"], event['ip_version'])
    event['step_validate_ip_3p'] = "ok"
    return event

event_handler({
   "ip_address": "2001:4860:4801:51::/64",
   "detection_source": "manual",
   "alert_name": "test",
   "alert_severity": "high",
    "ip_version": 6
}, None)
