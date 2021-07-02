import requests

url1 = "https://uat-data-demographics-nice-source.s3.amazonaws.com/report.html?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAWG4WXMHZTSRNFEMN%2F20210701%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20210701T175340Z&X-Amz-Expires=120&X-Amz-SignedHeaders=host&X-Amz-Signature=73b93cc6032d9c2d29aec067d7d7eaa5f06ff282707f026fc0e8c7b900c40309"

test = requests.get(url1)

print(test.content)

url = "https://90518xb4n6.execute-api.us-east-2.amazonaws.com/test"
params = {"product_id": "A2SUAM1J3GNN3B"}
response = requests.get(f"{url}/get_reviews", params=params)

print(response.content)

token = "fyJraWQiOiJtUEl5XC9vSnFWSmxaRVVtT3JFWjlMaE11b0ZoRDVCOXlOZUxFRW5va01kZz0iLCJhbGciOiJSUzI1NiJ9.eyJhdF9oYXNoIjoiS25xUHpXTGZJc1lhNWYtZS1lNnVKZyIsInN1YiI6Ijk2OTljZTEyLWM4NWQtNGM0Ni04YjM4LTJkNTE5MzYzMDZmYyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0yLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMl82TWhRQ09IdUciLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImNvZ25pdG86dXNlcm5hbWUiOiJkZWVwYWsiLCJhdWQiOiIxdmk2ZWdvcGRzNWs3OWQ4MHJ1MzNtZDFyaiIsImV2ZW50X2lkIjoiNzQ1MjlhZDMtZTExZS00ZjAyLWJiMmMtNDdkNGZlZGM2YTI4IiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE2MjQ1NDgyMzMsInBob25lX251bWJlciI6IisxMjI0MjI4MzYzMiIsImV4cCI6MTYyNDU1MTgzMywiaWF0IjoxNjI0NTQ4MjMzLCJqdGkiOiIxODFmYjMwYi0yNTgwLTRlNmMtOWJhNS0wODUxMmNiMmViZDMiLCJlbWFpbCI6ImRlZXBhay5kaXQyMDA5QGdtYWlsLmNvbSJ9.B262-l3zOO9pcg7Vl9GEV7eDIwDnTD2c4LZq7lW6_IZcX_Co8IUu4-s5A-7Numc7e0v1IIk2a3hbXWIeuPOW5-2aG2rR6K9_6bhFXY5Tf3-jYpXb70DM4dvnvHT-_t081x7h845K_k5CtY2-nW-u2yUwaaG9glq_hpo0swrcvnVVB2uU7BgUQ2MkNVXYxU6slO2bW7Tb6Quqi-FBkyoo-wuVvvxcyqeOOSP01BYM0L5pnGGCWjDgPrm9ehTiXPr7CWWA98dGmUwcNUtn8q04gPK5CVh7GiWiCWJDiY-ODuCU8tcb4nismz0lqiFLzFlear7P9eZEfio_BktZJ06eEA"
#
response2 = requests.post(f"{url}/create_report",
                          headers={'Authorization': token})

print(response2.json())


{
  "Comment": "This is your state machine",
  "StartAt": "Lambda Invoke",
  "States": {
    "Lambda Invoke": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-2:427128480243:function:get_reviews:$LATEST",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:us-east-2:427128480243:function:get_reviews:$LATEST"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
