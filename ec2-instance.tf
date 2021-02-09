resource "aws_instance" "my-instance" {
  count = length(var.subnets_cidr)
  ami = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.prod-web-servers-sg.id]
  subnet_id = element(aws_subnet.private.*.id,count.index)
  tags = {
    Name  = "prod-web-server-${count.index + 1}"
  }
}