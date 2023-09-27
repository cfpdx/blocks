##################################################################
# DNS
##################################################################

data "aws_route53_zone" "primary" {
  name         = var.registered_domain
  private_zone = false
}

module "records" {
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