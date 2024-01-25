resource "aws_lambda_function" "example_lambda" {
  function_name = "${var.app_name}_${var.environment}_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"

  timeout     = 60
  memory_size = 512
  depends_on  = [null_resource.local_image]
  tags        = var.tags
}

resource "aws_api_gateway_rest_api" "example_api" {
  name        = "${var.app_name}_${var.environment}_api_gateway"
  description = "This is my API for learning purposes"
}

resource "aws_api_gateway_resource" "example_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "${var.app_name}_${var.environment}"
}

resource "aws_api_gateway_method" "example_api_method_hello" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.example_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.example_api_resource.id
  http_method             = aws_api_gateway_method.example_api_method_hello.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda.invoke_arn
}

resource "aws_lambda_permission" "example_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/${aws_api_gateway_method.example_api_method_hello.http_method}/hello"
}
