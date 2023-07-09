
# IAM
resource "aws_iam_role" "codebuild_role" {
  count = 1
  name  = format("cu%s_codebuild_deploy_role", var.app_name)
  assume_role_policy = data.aws_iam_policy_document.custom_role.json
/*
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
*/
}


data "aws_iam_policy_document" "custom_role" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

  }
}


# to define policy i could use https://registry.terraform.io/providers/hashicorp/aws/2.33.0/docs/data-sources/iam_policy_document
// no S3 I don't use it
// no code commit, github ???
// no I need it only if I execute git clone inside the buildspec https://docs.aws.amazon.com/codepipeline/latest/userguide/troubleshooting.html#codebuild-role-connections
// need cloudwatch
// need ecr
// https://docs.aws.amazon.com/codebuild/latest/userguide/auth-and-access-control-iam-identity-based-access-control.html#ecr-policies
// need ec2 ??? I did some test i don't need it
data "aws_iam_policy_document" "custom_policy" {
    statement {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        resources = ["*"]
        actions = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:BatchDeleteImage"
        ]
    }
}


resource "aws_iam_role_policy" "codebuild_deploy" {
  role       = aws_iam_role.codebuild_role[0].name
  policy = data.aws_iam_policy_document.custom_policy.json
}


/*
resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
  role       = aws_iam_role.codebuild_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # this work fine :)
  # policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess" # cannot use this policy misses the ECR write (only read)
  # policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess" # cannot use this policy misses the ECR
  # I think i need a custom policy :(
}
*/

resource "aws_codebuild_project" "codebuild_project" {
  name          = format("cu%s", var.app_name)
  description   = format("cu%s desc", var.app_name)
  build_timeout = "120"
  service_role = aws_iam_role.codebuild_role[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/gigiozzz/cu331t-codebuild-src.git"
    git_clone_depth = 1
    buildspec       = format("buildspec-%s.yaml", var.app_name)
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
      value = var.app_repo
    }

    environment_variable {
      name  = "REGISTRY"
      value = var.registry
    }

  }

  tags = {
    Environment = "Test"
  }

}