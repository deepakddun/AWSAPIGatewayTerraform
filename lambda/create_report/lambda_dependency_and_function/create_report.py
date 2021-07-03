import json
import base64
import os
import boto3
import logging
from botocore.exceptions import ClientError

step_function = boto3.client('stepfunctions' ,region_name = 'us-east-2')
logger = logging.getLogger(__name__)




def lambda_handler(event, context):
    token_str = ""
    ipv4_str = ""
    decoded = {}
    return_me = {}
    name_str = ""
    extract_str = ""
    cell_str = ""
    return_me["message_str"] = "Report processing, check your phone shortly"
    if "Authorization" in json.dumps(event):
        # i.e we are at the website and have a valid Bearer token passed
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
        if os.environ.get('STEP_ARN'):
            start_stepfunction(os.environ.get('STEP_ARN') , {"cellphone_str":cell_str,"ipv4_str":"deepak.dit2009@gmail.com"})

    return return_me


def start_stepfunction(step_function_arn , payload):
    try:
        response = step_function.start_execution(stateMachineArn = step_function_arn,
            input= json.dumps(payload)
        )
        logger.info(f"Started step function {response['executionArn']}  at {response['startDate']}")
    except ClientError as e:
        logger.exception("Could created state machine")
        raise
