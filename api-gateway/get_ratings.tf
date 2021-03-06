resource "aws_api_gateway_resource" "get_rating_resource" {
  parent_id   = aws_api_gateway_rest_api.first_api.root_resource_id
  path_part   = "get_reviews"
  rest_api_id = aws_api_gateway_rest_api.first_api.id
}

# Lambda permission
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.get_reviews_lambda_function
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.first_api.id}/*/${aws_api_gateway_method.get_rating_method.http_method}${aws_api_gateway_resource.get_rating_resource.path}"
}

resource "aws_api_gateway_method" "get_rating_method" {
  rest_api_id   = aws_api_gateway_rest_api.first_api.id
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.get_rating_resource.id
  request_parameters = {
    "method.request.querystring.product_id" : false
  }

}

/*resource "aws_api_gateway_integration" "get_rating_integration" {

  rest_api_id = aws_api_gateway_rest_api.first_api.id
  http_method = aws_api_gateway_method.get_rating_method.http_method
  resource_id = aws_api_gateway_resource.get_rating_resource.id
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode : 200
      }
    )
  }
}*/

resource "aws_api_gateway_integration" "get_rating_integration" {
  rest_api_id             = aws_api_gateway_rest_api.first_api.id
  resource_id             = aws_api_gateway_resource.get_rating_resource.id
  http_method             = aws_api_gateway_method.get_rating_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:427128480243:function:get_reviews/invocations"
  request_templates = {
    "application/json" = jsonencode({
      "product_id_str": "$input.params().querystring.get('product_id')"
    })
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

/*resource "aws_api_gateway_integration_response" "first_integration_response" {
  depends_on  = [aws_api_gateway_integration.get_rating_integration, aws_api_gateway_method_response.get_rating_method_response]
  http_method = "GET"
  resource_id = aws_api_gateway_resource.get_rating_resource.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_templates = {
    "application/json" = jsonencode({
      "product_id_str" : "$input.params('product_id')", //just echoing what was sent
      "reviews_arr" : [{
        "review_body_str" : "Both the dropcam and nest cam have an embarrassingly bad WIFI algorithm when there are multiple access points with the same name (SID) near it.  (I have a tall house and I need multiple WIFI access points)  When you have this situation, the cameras lose connectivity all the time. The obvious workaround is to dedicate a WIFI access point specifically for the Nest Cam, which is annoying.  Why Nest can't or won't fix this is beyond me.  I know of no other WIFI enabled device that is this dumb about WIFI connectivity.  Until this is fixed it stays a 3",
        "rating_int" : 3
        }, {
        "review_body_str" : "It was easy to setup with a small hiccup during the scanning of the barcode on the back.  I still have issues with the software not loading correctly on my phone which customer service has said they are working on fixing.  The app hangs quite often when loading it from a push notification where I either get single spinners or double spinners.<br /><br />I do wish the monthly/yearly fees for video retention were better or there was maybe a network based solution for video storage as I would like to buy more of these and use them as a whole house system but would get quite pricy",
        "rating_int" : 3
        }, {
        "review_body_str" : "I've had this device for a few weeks now and I really like it.  It was easy to setup and it's easy to use.  I already have a Nest thermostat which I love and I now use the same app (on Android) to manage the camera.  It is really cool to be able to view the camera from my phone wherever I am.  There are some small kinks which seem to need work in the app.  For example, clicking on the notification will open the app and infinitely try to load the image from the camera history.  If you don't pay for the history it was just infinitely load... you could wait an hour it will never load an image.  You have to back out of the app and open it again to see the image.  Also, the camera should come with at least one day or a few hours of video history included for free.  It would be great to have the option to cache video history to my own computer or network device.  Without paying the subscription fee you have ZERO video history.  You will get a notification that the camera detected motion.... but you can't see it because it's usually over before you can open the app.  The camera is pretty much useless without video history... but the prices for history are not cheap.  If you don't mind paying a monthly fee... it's a great device with excellent build quality and image quality.",
        "rating_int" : 4
        }, {
        "review_body_str" : "I was hoping to use this for outdoor surveillance.  Proved to be too difficult to isolate zones where breezy plants wouldn't trigger unwanted alerts.  On one occasion, I received motion alerts when camera was allegedly off, which made me uncomfortable about when video was/wasn't being sent to cloud.  App had a bad habit of turning off my motion zones so my alerts were not useful.  Camera pours off heat.  Seems overall like an unrefined product not on par with the Nest thermostat which I own and like.",
        "rating_int" : 3
      }]
      }
    )
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'GET'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'"
  }

}*/

resource "aws_api_gateway_integration_response" "first_integration_response" {

  http_method = "GET"
  resource_id = aws_api_gateway_resource.get_rating_resource.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'GET'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'"
  }
  depends_on = [aws_api_gateway_integration.get_rating_integration, aws_api_gateway_method_response.get_rating_method_response]

}

resource "aws_api_gateway_model" "first_model" {
  rest_api_id  = aws_api_gateway_rest_api.first_api.id
  content_type = "application/json"
  name         = "getreviewsmodel"
  schema = jsonencode({

    "$schema" : "http://json-schema.org/draft-04/schema#",
    "title" : "VideoCameraStoreModel",
    "type" : "object",
    "properties" : {
      "product_id" : {
        "type" : "string"
      }
    }
  })
}

resource "aws_api_gateway_method_response" "get_rating_method_response" {
  http_method = aws_api_gateway_method.get_rating_method.http_method
  resource_id = aws_api_gateway_resource.get_rating_resource.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : false,
    "method.response.header.Access-Control-Allow-Origin" : false,
    "method.response.header.Access-Control-Allow-Methods" : false
  }

}

