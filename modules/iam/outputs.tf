output lambda_exec_role_arn {
    description = "arn for lambda execution role"
    value = aws_iam_role.lambda_exec_role.arn
}