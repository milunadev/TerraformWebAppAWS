resource "aws_instance" "instance_1" {
  # Regla de seguridad para permitir todo el tráfico interno desde la red por defecto
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name = "TerraformVMKeys"
  tags = {
    Name =  var.ec2_name
  }
  security_groups = [ aws_security_group.MilunaWEB_EC2_SG.name]
  iam_instance_profile = aws_iam_instance_profile.EC2_s3_role_profile.name
  user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install ruby-full
    sudo apt install wget -y
    cd /home/ubuntu
    sudo wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
    sudo ./install auto
  EOF
}

