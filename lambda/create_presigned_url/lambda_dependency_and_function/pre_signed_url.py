import boto3
import logging
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    s3 = boto3.client('s3', region_name='us-east-2')

    response = None
    try:

        response = s3.generate_presigned_url('get_object', Params={'Bucket': 'uat-data-demographics-nice-source',
                                                                   'Key': 'report.html'},
                                             ExpiresIn=60 * 2
                                             )
    except ClientError as e:
        logging.error(e)
        return None

    return response



