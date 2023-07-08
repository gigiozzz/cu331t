terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.4.2"
}

provider "aws" {
  region = "us-east-1"
}

## https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
resource "aws_ecr_repository" "ecr" {
  for_each             = toset(var.ecr_names)
  name                 = each.key
  image_tag_mutability = var.image_mutability
  encryption_configuration {
    encryption_type = var.encrypt_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}
