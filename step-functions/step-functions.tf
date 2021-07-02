resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "my-state-machine"
  role_arn = aws_iam_role.custom_step_function_role.arn

  definition = file("${path.module}/definition.json")

  depends_on = [aws_iam_role_policy_attachment.policy_attachment]
}