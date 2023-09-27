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
      name = ""
      type = "A"
      alias = {
        name    = module.alb.lb_dns_name
        zone_id = "Z35SXDOTRQ7X7K"
      }
    }
  ]
}

module "api_records" {
  source = "../../modules/dns/records"

  zone_name = data.aws_route53_zone.primary.name
  zone_id   = data.aws_route53_zone.primary.id

  records = [
    {
      name = ""
      type = "A"
      alias = {
        name    = module.api_gateway.apigatewayv2_api_api_endpoint
        zone_id = "Z35SXDOTRQ7X7K"
      }
    }
  ]
}