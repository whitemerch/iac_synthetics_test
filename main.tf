resource "aws_security_group" "this" {
  name   = format("cross-cluster-sg-%s", var.service)
  vpc_id = var.vpc_id

  tags = merge(local.common_tags, {
    Name = format("cross-cluster-sg-%s", var.service)
  })
}

resource "aws_lb_target_group" "this" {
  name        = format("cross-cluster-tg-%s", var.service)
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = local.common_tags
}

resource "aws_acm_certificate" "service" {
  domain_name       = format("%s.%s", var.service, local.domain)
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}
