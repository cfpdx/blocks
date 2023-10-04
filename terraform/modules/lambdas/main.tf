resource "aws_lambda_function" "this" {
  function_name                      = var.function_name
  description                        = var.description
  role                               = aws_iam_role.execution_role.arn
  handler                            = var.handler
  runtime = var.runtime
  filename                  = var.filename
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.api_source_arn}/*"
}

resource "aws_iam_role" "execution_role" {
  name = "${var.function_name}-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = var.iam_policies
  policy_arn = each.value
  role       = aws_iam_role.execution_role.name
}