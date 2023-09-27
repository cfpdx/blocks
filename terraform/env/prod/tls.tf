##################################################################
# Encrypt In-Transit
##################################################################

module "webcert" {
  source = "../../modules/acm"

  providers = {
    aws.acm = aws,
    aws.dns = aws
  }
  domain_name = var.registered_domain
  zone_id     = data.aws_route53_zone.primary.id

  tags = {
    Name = "${var.registered_domain}-tls-cert"
  }
}

module "apicert" {
  source = "../../modules/acm"

  providers = {
    aws.acm = aws,
    aws.dns = aws
  }
  domain_name = var.api_subdomain
  zone_id     = data.aws_route53_zone.primary.id

  tags = {
    Name = "${var.api_subdomain}-tls-cert"
  }
}