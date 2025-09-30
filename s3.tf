terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # or the latest version
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# Create S3 bucket
resource "aws_s3_bucket" "ecommerce_raw" {
  bucket        = "ecommerce-raw-pp-dev"
  force_destroy = true

  tags = {
    Name        = "ecommerce-raw-pp-dev"
    Environment = "dev"
  }
}

# Create a folder inside the S3 bucket
resource "aws_s3_object" "ecomm_user_activity_sample_folder" {
  bucket = aws_s3_bucket.ecommerce_raw.id
  key    = "ecomm_user_activity_sample/" # Folder key with trailing slash
  acl    = "private"
}

# Upload file to the S3 folder
resource "aws_s3_object" "sample_csv_upload" {
  bucket = aws_s3_bucket.ecommerce_raw.id
  key    = "ecomm_user_activity_sample/2019-Oct-sample.csv" # File path in S3
  source = "${path.module}/2019-Oct-sample.csv" # File in Terraform script folder
  acl    = "private"

  content_type = "text/csv"

  tags = {
    Name        = "2019-Oct-sample.csv"
    Environment = "dev"
  }
}
