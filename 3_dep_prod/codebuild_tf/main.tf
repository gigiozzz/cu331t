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

# IAM
resource "aws_iam_role" "codebuild_role" {
  count = 1
  name  = "cuapp_codebuild_deploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
  role       = aws_iam_role.codebuild_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_codebuild_project" "codebuild_project" {
  name          = "cuapp"
  description   = "cuapp desc"
  build_timeout = "120"
  #service_role  = var.create_role_and_policy ? aws_iam_role.codebuild_role[0].arn : var.codebuild_role_arn
  service_role  = aws_iam_role.codebuild_role[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/gigiozzz/cu331t-codebuild-src.git"
    git_clone_depth = 1
    buildspec       = "buildspec-app.yaml"
    git_submodules_config {
      fetch_submodules = true
    }
  }

  environment {
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "TAG"
      value = "0.1.0"
    }

    environment_variable {
      name  = "REPO"
      value = "795496658604.dkr.ecr.us-east-1.amazonaws.com/cuapp"
    }
  }

  tags = {
    Environment = "Test"
  }

}