variable "ec2_name" {
  description = "Nombre de la instancia ec2"
  type = string
}

variable "HTTPScertificate_arn" {
  description = "ARN del certificado emitido por AWS"
  type = string
  sensitive = true
}

