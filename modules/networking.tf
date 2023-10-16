data "aws_vpc" "default_vpc" {
  default = true
}

#The following shows outputting all CIDR blocks for every subnet ID in a VPC.
#Filtramos las subredes que pertenezcan al default vpc
data "aws_subnets" "default_subnets" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default_vpc.id ]
  }
}


####  GRUPOS DE SEGURIDAD ###

## EC2 INSTANCE ##
resource "aws_security_group" "MilunaWEB_EC2_SG" {
  name = "MiLunaEC2_SG"
}
resource "aws_security_group_rule" "allow_frontend" {
  type = "ingress"
  security_group_id = aws_security_group.MilunaWEB_EC2_SG.id
  from_port = 3000
  to_port = 3000
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "allow_ssh" {
  type = "ingress"
  security_group_id = aws_security_group.MilunaWEB_EC2_SG.id
  from_port = 22
  to_port = 22  
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "allow_all_internalEC2" {
  type = "ingress"
  security_group_id = aws_security_group.MilunaWEB_EC2_SG.id
  from_port = 0
  to_port = 65535
  protocol = "-1"
  cidr_blocks = [ data.aws_vpc.default_vpc.cidr_block ]
}

resource "aws_security_group_rule" "allow_outboundEC2" {
  type              = "egress"
  security_group_id = aws_security_group.MilunaWEB_EC2_SG.id
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

## LOAD BALANCER ##
resource "aws_security_group" "MilunaWEB_LB_SG" {
  name = "MiLunaLB_SG"
}

resource "aws_security_group_rule" "allow_all_internalLB" {
  type = "ingress"
  security_group_id = aws_security_group.MilunaWEB_LB_SG.id
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "allow_outboundLB" {
  type              = "egress"
  security_group_id = aws_security_group.MilunaWEB_LB_SG.id
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}