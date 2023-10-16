## LOAD BALANCER ##
resource "aws_lb" "MilunaWEB_LB" {
  name = "${var.ec2_name}LoadBalancer"
  load_balancer_type = "application"
  subnets = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.MilunaWEB_LB_SG.id]
}

## GRUPOS DE DESTINO ##

resource "aws_lb_target_group" "milunadevFrontend" {
  name = "${var.ec2_name}FrontEnd-TG"
  port = 3000
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id

  health_check {
    path = "/"
    protocol            = "HTTP"
    matcher             = "200"

  }
}
resource "aws_lb_target_group_attachment" "frontend" {
  target_group_arn = aws_lb_target_group.milunadevFrontend.arn
  target_id        = aws_instance.instance_1.id
  port             = 3000
}


resource "aws_lb_target_group" "milunadevBackend" {
  name = "${var.ec2_name}BackEnd-TG"
  port = 3001
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id 

  health_check {
    path = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }
}
resource "aws_lb_target_group_attachment" "backend" {
  target_group_arn = aws_lb_target_group.milunadevBackend
  target_id        = aws_instance.instance_1.id
  port             = 3001
}


## AGENTES DE ESCUCHA ##
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.MilunaWEB_LB.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.HTTPScertificate_arn

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
    ## REGLAS DEL AGENTE DE ESCUCHA ##
resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.milunadevFrontend.arn
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/consultas"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.milunadevBackend.arn
  }
}