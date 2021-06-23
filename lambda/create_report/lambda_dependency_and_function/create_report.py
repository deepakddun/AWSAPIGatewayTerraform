import json
import base64

def lambda_handler(event, context):
    token_str = ""
    ipv4_str = ""
    decoded = {}
    return_me = {}
    name_str = ""
    extract_str = ""
    cell_str = ""
    return_me["message_str"] =  "Report processing, check your phone shortly"
    if "Authorization" in json.dumps(event):
        #i.e we are at the website and have a valid Bearer token passed
        token_str = event["params"]["header"]["Authorization"]
        extract_str = token_str.replace("Bearer ", "").strip().split(".")[1]
        extract_str += '=' * (-len(extract_str) % 4)
        decoded = json.loads(base64.b64decode(extract_str))
        cell_str = decoded["phone_number"]
        name_str = decoded["cognito:username"]
        ipv4_str = event["params"]["header"]["X-Forwarded-For"]
        return_me["cell_str"] = cell_str
        return_me["name_str"] = name_str
        return_me["name_str"] = decoded["cognito:username"]
        return_me["ipv4_str"] = ipv4_str
        return_me["message_str"] = "Report Processing"
    return return_me