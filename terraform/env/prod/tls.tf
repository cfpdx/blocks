locals {
  # Use existing (via data source) or create new zone (will fail validation, if zone is not reachable)
  use_existing_route53_zone = true
  domain_name = var.registered_dns_name
  zone_id = module.aws_route53_zone.this[0].zone_id
}

module "acm" {
  source = "../../modules/acm "

  providers = {
    aws.acm = aws,
    aws.dns = aws
  }
  domain_name = local.domain_name
  zone_id     = local.zone_id

  tags = {
    Name = local.domain_name
  }
}