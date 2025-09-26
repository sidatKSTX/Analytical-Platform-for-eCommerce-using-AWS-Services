# IAM Role for Kinesis Data Analytics Studio
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "AWSKinesisAnalyticsStudioRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Role for Apache Flink Application
resource "aws_iam_role" "flink_application_role" {
  name = "AWSFlinkApplicationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policies for Kinesis Data Analytics Studio
resource "aws_iam_policy_attachment" "glue_access" {
  name       = "glue_access"
  roles      = [aws_iam_role.kinesis_analytics_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_policy_attachment" "kinesis_access" {
  name       = "kinesis_access"
  roles      = [aws_iam_role.kinesis_analytics_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_policy_attachment" "s3_access" {
  name       = "s3_access"
  roles      = [aws_iam_role.kinesis_analytics_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "lambda_access" {
  name       = "lambda_access"
  roles      = [aws_iam_role.kinesis_analytics_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_policy_attachment" "glue_service_access" {
  name       = "glue_service_access"
  roles      = [aws_iam_role.kinesis_analytics_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_policy_attachment" "kinesis_analytics_access" {
  name       = "kinesis_analytics_access"
  roles      = [aws_iam_role.kinesis_analytics_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisAnalyticsFullAccess"
}

# Attach Policies for Apache Flink Application
resource "aws_iam_policy_attachment" "flink_kinesis_access" {
  name       = "flink_kinesis_access"
  roles      = [aws_iam_role.flink_application_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_policy_attachment" "flink_glue_service_access" {
  name       = "flink_glue_service_access"
  roles      = [aws_iam_role.flink_application_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_policy_attachment" "flink_analytics_access" {
  name       = "flink_analytics_access"
  roles      = [aws_iam_role.flink_application_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisAnalyticsFullAccess"
}

# S3 Access for Checkpoints & Savepoints
resource "aws_iam_policy_attachment" "flink_s3_access" {
  name       = "flink_s3_access"
  roles      = [aws_iam_role.flink_application_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# CloudWatch Logs Access for Flink Monitoring
resource "aws_iam_policy_attachment" "flink_logs_access" {
  name       = "flink_logs_access"
  roles      = [aws_iam_role.flink_application_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
