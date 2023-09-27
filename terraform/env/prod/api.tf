##################################################################
# API Gateway
##################################################################

locals {
  domain_name = var.api_subdomain
}

module "api_gateway" {
  source = "../../modules/apigateway"

  name          = "hello-http-api"
  description   = "HTTP API Gateway for ${local.domain_name}"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  domain_name                 = local.domain_name
  domain_name_certificate_arn = module.apicert.acm_certificate_arn

  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }

  integrations = {
    "$default" = {
      lambda_arn             = module.hello_world.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  tags = {
    Name = "${var.application_prefix}-apigw"
  }
}

module "hello_world" {
  source = "../../modules/lambdas"

  function_name = "hello-lamdba"
  description = "Returns a 200 hello world packet"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  filename = "../../modules/lambdas/definitions/helloworld.js.zip"
}
