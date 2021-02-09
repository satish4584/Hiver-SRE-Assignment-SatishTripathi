resource "aws_lb" "prod-nlb" {
  name   = "prod-nlb"
  load_balancer_type  = "network"
  availability_zones = [var.azs]
  subnets = [
    aws_subnet.private.*.id]
  security_groups = [aws_security_group.prod-web-servers-sg.id]

  http_tcp_listeners   {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = [aws_instance.my-instance.*.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags {
    Name = "prod-nlb"
  }
}