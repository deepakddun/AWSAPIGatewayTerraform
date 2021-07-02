
resource "aws_iam_policy" "lambda_step_functions_policy_terraform" {
  name = "lambda_step_functions_terraform_policy"
  description = "the policy to be attached to iam role"
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
            Effect: "Allow",
            Action: "lambda:InvokeFunction",
            Resource: "arn:aws:lambda:*:427128480243:function:*"
        }
    ]
})
}



resource "aws_iam_role" "custom_step_function_role" {
  name = "custom_step_function_role"
  depends_on = [aws_iam_policy.lambda_step_functions_policy_terraform]
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Principal: {
                "Service":"states.amazonaws.com"
            },
            Action: "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.lambda_step_functions_policy_terraform.arn
  role = aws_iam_role.custom_step_function_role.name
  depends_on = [aws_iam_policy.lambda_step_functions_policy_terraform , aws_iam_role.custom_step_function_role]
}

