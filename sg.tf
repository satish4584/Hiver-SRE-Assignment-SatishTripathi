resource "aws_security_group" "prod-web-servers-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
ingress {
    description = "Allow TCP port 80"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }


  tags = {
    Name = "allow Http and TCP"
  }
}
