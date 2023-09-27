resource "aws_lambda_function" "this" {
  function_name                      = var.function_name
  description                        = var.description
  role                               = aws_iam_role.lambda_role.arn
  handler                            = var.handler
  runtime = var.runtime
  filename                  = var.filename
}
