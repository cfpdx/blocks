##################################################################
# DNS
##################################################################

data "aws_route53_zone" "primary" {
  name         = var.registered_domain
  private_zone = false
}

module "web_records" {
  source = "../../modules/dns/records"

  zone_name = data.aws_route53_zone.primary.name
  zone_id   = data.aws_route53_zone.primary.id

  records = [
    {
      # defaults to hz dns
      name = ""
      type = "A"
      alias = {
        name    = module.alb.lb_dns_name
        zone_id = module.alb.lb_zone_id
      }
    },
    {
      name = "api.${var.registered_domain}"
      type = "A"
      alias = {
        name    = module.api_gateway.apigatewayv2_api_api_endpoint
        zone_id = module.api_gateway.apigatewayv2_domain_name_hosted_zone_id
      }
    },
    {
      name = "assets.${var.registered_domain}"
      type = "A"
      alias = {
        name    = var.assets_cloudfront_endpoint
        zone_id = module.api_gateway.apigatewayv2_domain_name_hosted_zone_id
      }
    }
  ]
}
