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

resource "aws_lb" "this" {
  name               = format("cross-cluster-nlb-%s", var.service)
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnets

  tags = local.common_tags
}
