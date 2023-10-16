terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "MILUNADEV"

    workspaces {
      name = "TerraformWebAppAWS"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

module "webApp1" {
  source = "./modules"

  #Input variables
  ec2_name = var.ec2_name
  HTTPScertificate_arn = var.HTTPScertificate_arn

}