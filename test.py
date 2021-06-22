import boto3
import json
import statistics
import re


def lambda_handler(event=None, context=None):
    reviewerID =  'A2SUAM1J3GNN3B'
    S3_BUCKET = 'api-gateway-product-bucket'
    S3_FILE = 'product_review.json'
    # S3_BUCKET = 'aws-tc-largeobjects'
    # S3_FILE = 'DEV-AWS-MO-Building_2.0/my_json_lines.jsonl'

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

print(lambda_handler())