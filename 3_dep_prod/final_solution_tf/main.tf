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

locals {
  apps = ["app","rp"]
}

module "ecr" {
  source    = "./modules/ecr"
  ecr_names = local.apps
}

module "codebuild" {
  source   = "./modules/codebuild"
  for_each = toset(local.apps)

  app_name = each.key
  app_repo = module.ecr.repository_url[each.key]
  registry = split("/",module.ecr.repository_url[each.key])[0]
}