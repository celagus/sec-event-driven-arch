from ipaddress import ip_network, ip_address, IPv4Address, IPv6Address

class NoIPAddress(Exception):
    pass

class NoValidIPAddress(Exception):
    pass


def is_valid_ip(address: str) -> bool:
    try:
        ip = ip_address(address)
        return ip.is_global
    except:
        raise NoValidIPAddress


def event_handler(event, context):
    if "ip_address" in event.keys() and is_valid_ip(event["ip_address"]):
        try:
            IPv4Address(event["ip_address"])
            version = 4
        except:
            IPv6Address(event["ip_address"])
            version = 6
        event['step_validate_ip'] = "ok"
        event['ip_version'] = version
        return event
    else:
        raise NoIPAddress
