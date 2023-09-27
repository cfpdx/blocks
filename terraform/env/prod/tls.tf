##################################################################
# Encrypt In-Transit
##################################################################

module "acm" {
  source = "../../modules/acm"

  providers = {
    aws.acm = aws,
    aws.dns = aws
  }
  domain_name = var.registered_domain
  zone_id     = data.aws_route53_zone.primary.id

  tags = {
    Name = var.registered_domain
  }
}