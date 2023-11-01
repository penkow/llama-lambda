provider "aws" {
  region = "us-east-1" # Change to your desired AWS region
}

resource "aws_lambda_function" "llama_lambda" {
  function_name = "llama-lambda"
  role          = aws_iam_role.llama_lambda_role.arn
  package_type  = "Image"
  image_uri     = "**Put your AWS Lambda ECR image link her**"
  timeout       = 900
  memory_size   = 10240
}


resource "aws_lambda_function_event_invoke_config" "llama_lambda_event_config" {
  function_name          = aws_lambda_function.llama_lambda.function_name
  maximum_retry_attempts = 0
}

data "aws_iam_policy_document" "llama_lambda_custom_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "llama_lambda_custom_policy" {
  name   = "LlamaLambdaPolicy"
  policy = data.aws_iam_policy_document.llama_lambda_custom_policy_document.json
}

resource "aws_iam_role_policy_attachment" "llama_lambda_role_custom_policy_attachment" {
  role       = aws_iam_role.llama_lambda_role.name
  policy_arn = aws_iam_policy.llama_lambda_custom_policy.arn
}

resource "aws_iam_role" "llama_lambda_role" {
  name        = "llama-lambda-role"
  description = "Role for llama-lambda function"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
