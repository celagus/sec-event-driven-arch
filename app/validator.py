import ipaddress

# Custom exception for not valid IP (includes public IP validation)
class NoValidIP(Exception):
    pass

def is_valid_ip(address: str) -> bool:
    response = False
    try:
        ip = ipaddress.ip_address(address)
        if ip.is_global:
            response = True
        return response
    except:
        raise NoValidIP

 