import boto3


def lambda_handler(event, context):
    result_boo = False
    safe_cellphone_str = "+12242283632"
    safe_ipv4_str = "deepak.dit2009@gmail.com"
    cellphone_str = event.get("cellphone_str", None)
    ipv4_str = event.get("ipv4_str", None)
    if cellphone_str and ipv4_str:
        if safe_cellphone_str == cellphone_str and ipv4_str == safe_ipv4_str:
            result_boo = True
        else:
            result_boo = False
    else:
        result_boo = False

    return result_boo
