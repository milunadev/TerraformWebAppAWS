resource "aws_instance" "instance_1" {
  # Regla de seguridad para permitir todo el tráfico interno desde la red por defecto
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name = "TerraformVMKeys"
  tags = {
    Name =  var.ec2_name
  }
  security_groups = [ aws_security_group.MilunaWEB_EC2_SG.name]
  user_data = <<EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt install curl -y
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    NODE_MAJOR=18
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt-get update
    sudo apt-get install nodejs -y

    git clone https://github.com/milunadev/Dashbotv2
    cd Dashbotv2
    sudo npm ci 
  EOF
}

