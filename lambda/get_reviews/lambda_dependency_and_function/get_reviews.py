import json
import boto3
import os


def handler(event, context):
    BUCKET_NAME = os.getenv('BUCKET_NAME', 'api-gateway-product-bucket')
    KEY_NAME = os.getenv('S3_FILE', 'product_review.json')

    reviewerID = event['product_id_str'] or 'A2SUAM1J3GNN3B'

    s3 = boto3.client('s3', region_name='us-east-2')
    print(BUCKET_NAME, KEY_NAME)
    r = s3.select_object_content(
        Bucket=BUCKET_NAME,
        Key=KEY_NAME,
        ExpressionType='SQL',
        Expression=f"select s.summary , s.reviewText from s3object[*][*] s where s.reviewerID = '{reviewerID}'",
        InputSerialization={'JSON': {"Type": "Lines"}},
        OutputSerialization={'JSON': {}}
    )

    f_results = []

    for event in r['Payload']:
        if 'Records' in event:
            records = event['Records']['Payload'].decode('utf-8')
            print(f"records 1 {records}")
            f_results = records.splitlines()

    final_result = []
    for line in f_results:
        final_result.append(json.loads(line))

    return_object = {
        "product_id_str": reviewerID,
        "reviews_arr": final_result
    }

    return return_object
