# ------------------------------------------
# SNS Topic & Email Subscription
# ------------------------------------------
resource "aws_sns_topic" "ecommerce_sns" {
  name = "ecommerce-high-severity-incidents"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.ecommerce_sns.arn
  protocol  = "email"
  endpoint  = "dataengineer3434@gmail.com"
}

# ------------------------------------------
# DynamoDB Table
# ------------------------------------------

resource "aws_dynamodb_table" "ecommerce_dynamodb" {
  name         = "ddb-ecommerce-tab-1"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "ddb_partition_key"
    type = "S"
  }

  attribute {
    name = "ddb_sort_key"
    type = "N" # Updated to Number
  }

  hash_key  = "ddb_partition_key"
  range_key = "ddb_sort_key"

  tags = {
    Name        = "ddb-ecommerce-tab-1"
    Environment = "dev"
  }
}

# ------------------------------------------
# IAM Role for Lambda Function
# ------------------------------------------
resource "aws_iam_role" "lambda_role" {
  name                = "ecommerce_lambda_role"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS-Managed Policies for Full Access
resource "aws_iam_policy_attachment" "lambda_execution" {
  name       = "lambda_execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy_attachment" "cloudwatch_full_access" {
  name       = "cloudwatch_full_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_policy_attachment" "dynamodb_full_access" {
  name       = "dynamodb_full_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_policy_attachment" "kinesis_full_access" {
  name       = "kinesis_full_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_policy_attachment" "sns_full_access" {
  name       = "sns_full_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

# ------------------------------------------
# AWS Lambda Function
# ------------------------------------------
resource "aws_lambda_function" "ecommerce_lambda" {
  function_name    = "ecommerce_lambda_function"
  runtime         = "python3.8"
  handler         = "lambda_function.lambda_handler"
  role            = aws_iam_role.lambda_role.arn

  filename        = "lambda.zip"  # Ensure this file is in the Terraform directory
  source_code_hash = filebase64sha256("lambda.zip")

  memory_size     = 256
  timeout         = 30

  # Environment Variables
  environment {
    variables = {
      cloudwatch_metric      = "ecomm-user-high-volume-events"
      cloudwatch_namespace   = "ecommerce-namespace-1"
      dynamodb_control_table = aws_dynamodb_table.ecommerce_dynamodb.name
      topic_arn              = aws_sns_topic.ecommerce_sns.arn
    }
  }
}

# ------------------------------------------
# Kinesis Data Stream Trigger for Lambda
# ------------------------------------------
resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  depends_on        = [aws_kinesis_stream.ecommerce_raw_user_activity2]
  event_source_arn  = aws_kinesis_stream.ecommerce_raw_user_activity2.arn
  function_name     = aws_lambda_function.ecommerce_lambda.arn
  starting_position = "LATEST" # Start processing new records

  batch_size = 1 # Process records in batches of 100
  enabled    = true
}

# ------------------------------------------
# Lambda Log Group
# ------------------------------------------
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.ecommerce_lambda.function_name}"
  retention_in_days = 7
}