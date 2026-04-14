provider "aws" {
  region  = "ap-south-1"
}

# 🔹 DynamoDB
resource "aws_dynamodb_table" "array_table" {
  name         = "ArraySortLogsTF"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "requestId"

  attribute {
    name = "requestId"
    type = "S"
  }
}

# 🔹 IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role_tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 🔹 IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# 🔹 Zip Lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda/lambda_function.py"
  output_path = "lambda.zip"
}

# 🔹 Lambda Function
resource "aws_lambda_function" "sort_lambda" {
  function_name = "array-sort-lambda-tf"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# 🔹 API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = "array-sort-api"
  protocol_type = "HTTP"
}

# 🔹 Integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.sort_lambda.invoke_arn
}

# 🔹 Route
resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /sort"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 🔹 Stage
resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# 🔹 Permission for API Gateway
resource "aws_lambda_permission" "api_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sort_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}