output "public_ip_EC2" {
  value = aws_instance.instance_1.public_ip
}