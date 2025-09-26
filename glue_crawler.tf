# IAM Role for AWS Glue Crawler
resource "aws_iam_role" "glue_crawler_role" {
  name = "AWSGlueServiceRole-EcommerceCrawler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policies to IAM Role
resource "aws_iam_policy_attachment" "glue_s3_access" {
  name       = "glue_s3_access"
  roles      = [aws_iam_role.glue_crawler_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create Glue Database
resource "aws_glue_catalog_database" "ecommerce_db" {
  name = "db_ecommerce_raw"
}

# Create Glue Crawler
resource "aws_glue_crawler" "ecommerce_crawler" {
  name          = "ecommerce-user-activity-crawler"
  database_name = aws_glue_catalog_database.ecommerce_db.name
  role          = aws_iam_role.glue_crawler_role.arn

  s3_target {
    path = "s3://ecommerce-raw-pp-dev/ecomm_user_activity_sample/"
  }

  schedule = "" # No schedule, running manually

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}

# Ensure Glue Crawler Runs After CSV Upload
resource "null_resource" "trigger_glue_crawler" {
  depends_on = [aws_s3_object.sample_csv_upload, aws_glue_crawler.ecommerce_crawler]

  provisioner "local-exec" {
    command = "aws glue start-crawler --name ecommerce-user-activity-crawler"
  }
}
