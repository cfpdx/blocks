##################################################################
# API Gateway
##################################################################

locals {
  domain_name = var.api_subdomain
}

module "api_gateway" {
  source = "../../modules/apigateway"

  name          = var.apigw_name
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
      lambda_arn             = module.apigw_health.lambda_function_arn
      payload_format_version = "2.0"
      throttling_rate_limit    = 80
      throttling_burst_limit   = 40
      timeout_milliseconds   = 12000
    }

    # "GET /get-s3" = {
    #   lambda_arn             = module.contrib_s3_get.lambda_function_arn
    #   payload_format_version = "2.0"
    #   throttling_rate_limit    = 80
    #   throttling_burst_limit   = 40
    #   timeout_milliseconds   = 12000
    # }
  }

  tags = {
    Name = "${var.application_prefix}-apigw"
  }
}