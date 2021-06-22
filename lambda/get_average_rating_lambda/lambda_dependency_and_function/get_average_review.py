import boto3
import statistics
import re
import os


def lambda_handler(event, context):
    reviewerID = event['product_id_str']
    S3_BUCKET = os.getenv('BUCKET_NAME')
    S3_FILE = os.getenv('S3_FILE')

    s3 = boto3.client('s3', region_name='us-east-2')

    r = s3.select_object_content(
        Bucket=S3_BUCKET,
        Key=S3_FILE,
        ExpressionType='SQL',
        Expression=f"select s.overall from s3object[*][*] s where s.reviewerID = '{reviewerID}'",
        InputSerialization={'JSON': {"Type": "Lines"}},
        OutputSerialization={'JSON': {}}
    )
    f_results = 0.0
    for event in r['Payload']:
        if 'Records' in event:
            records = event['Records']['Payload'].decode('utf-8')
            n_records = (re.findall(r'\d+', records))
            results = list(map(float, n_records))
            f_results = statistics.mean(results)

    return {
        'product_id_str': reviewerID,
        'average_star_review_float': f_results
    }
