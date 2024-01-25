provider "aws" {
  region = var.region
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ECRAccessPolicy"
  description = "Policy for ECR access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Resource": "${aws_ecr_repository.ecr_repo.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_ecr_access" {
  name  = "${var.app_name}_${var.environment}_ecr_access"
  roles = [aws_iam_role.lambda_exec_role.name]

  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.app_name}_${var.environment}_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}