data "aws_route53_zone" "primary" {
  name         = "codefriendspdx.com"
  private_zone = false
}


module "records" {
  source = "../../modules/records"

  zone_name = data.aws_route53_zone.primary.name
  zone_id   = data.aws_route53_zone.primary.id

  records = [
    {
      name = ""
      type = "CNAME"
      ttl  = 3600
      alias = {
        name    = module.
        zone_id = data.aws_route53_zone.id
      }
    },

  ]
}