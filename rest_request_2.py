import json

import requests

url = "https://90518xb4n6.execute-api.us-east-2.amazonaws.com/test"

token = "eyJraWQiOiJtUEl5XC9vSnFWSmxaRVVtT3JFWjlMaE11b0ZoRDVCOXlOZUxFRW5va01kZz0iLCJhbGciOiJSUzI1NiJ9.eyJhdF9oYXNoIjoidklQd0lUMm5EWER3RF9rQlcybm1PdyIsInN1YiI6Ijk2OTljZTEyLWM4NWQtNGM0Ni04YjM4LTJkNTE5MzYzMDZmYyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0yLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMl82TWhRQ09IdUciLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImNvZ25pdG86dXNlcm5hbWUiOiJkZWVwYWsiLCJhdWQiOiIxdmk2ZWdvcGRzNWs3OWQ4MHJ1MzNtZDFyaiIsImV2ZW50X2lkIjoiOGVmOWFhNWEtNzJhZC00YWUxLTg3NjItMjQ5ZWY3NjIzMmE2IiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE2MjUyMzk0NTksInBob25lX251bWJlciI6IisxMjI0MjI4MzYzMiIsImV4cCI6MTYyNTI0MzA1OSwiaWF0IjoxNjI1MjM5NDU5LCJqdGkiOiI5N2E0NDkxMC0xNzJmLTQ0NDktOWJlNS1jOWIzNTI0ODc3ODciLCJlbWFpbCI6ImRlZXBhay5kaXQyMDA5QGdtYWlsLmNvbSJ9.Cz49LtfYjWtqW-AXtm25VrXzFUK8J-X2oFqqHBAHoth68C92RYEbIzAQ0LOnborAxt7NNLmn8kSCdW1hW5w1EQAWQPs0ozOF8aTpBmuEEqv_MQ1IYNSO5rC2rPIMAipPeFsYUZ2geRLOicBIPQDoYyP7XgJsJG0fO5SSp-jSE4LRxgyO9nXOEE7CH2X3tjSD2-Yq_F9kRATJkrjbutBHTO2AOb4nFiOiXZSk_wdC9UVrPyIO5-iUWXi8Wux80wEWDZ5L7PWqJj8r2MZddGnr_fhJjI8PQV7ChJw8WGvFCuPgewmF-T0jz8FYkrrgeL3nasNC1Gjp4T4cAUfqJ-lZOA"
#
response2 = requests.post(f"{url}/create_report",
                          headers={'Authorization': token})

print(response2.json())

print(
    json.dumps({"name":"deepak"})
)

