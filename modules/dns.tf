data "aws_route53_zone" "primary" {
  name  = var.domain
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "miluna.dev"
  type    = "A"

  alias {
    name                   = aws_lb.MilunaWEB_LB.dns_name
    zone_id                = aws_lb.MilunaWEB_LB.zone_id
    evaluate_target_health = true
  }
}