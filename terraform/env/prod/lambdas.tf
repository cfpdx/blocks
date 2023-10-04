## Required Policies
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-basic-policy"
  description = "Basic policy for Lambda execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_lambda_policy" {
  name        = "s3-lambda-policy"
  description = "Policy for Lambda read on s3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
            "arn:aws:s3:::*",
            "arn:aws:s3:::*/*"
        ]
      }
    ]
  })
}

# LAMBDAS
## Health check
module "apigw_health" {
  source = "../../modules/lambdas"

  function_name = "hello-lamdba"
  description = "Returns a 200 hello world packet"
  handler       = "helloworld.handler"
  runtime       = "nodejs16.x"
  iam_policies = {
    default_policy = aws_iam_policy.lambda_policy.arn
  }
  api_source_arn = module.api_gateway.apigatewayv2_api_execution_arn
  filename = "../../modules/lambdas/definitions/helloworld.js.zip"
}

## S3 Get
module "contrib_s3_get" {
  source = "../../modules/lambdas"

  function_name = "s3-get"
  description = "GETs contents of s3 bucket and returns to caller"
  handler       = "s3get.handler"
  runtime       = "nodejs16.x"
  iam_policies = {
    default_policy = aws_iam_policy.lambda_policy.arn,
    s3_policy = aws_iam_policy.s3_lambda_policy.arn
  }
  api_source_arn = module.api_gateway.apigatewayv2_api_execution_arn
  filename = "../../modules/lambdas/definitions/s3get.js.zip"
}