resource "aws_instance" "instance_1" {
  # Regla de seguridad para permitir todo el tráfico interno desde la red por defecto
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name = "SSHVMs"
  tags = {
    Name =  var.ec2_name
  }
  security_groups = [ aws_security_group.MilunaWEB_EC2_SG.name]
}

