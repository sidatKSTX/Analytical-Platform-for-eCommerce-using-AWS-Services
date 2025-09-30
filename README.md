# Ecommerce Real-time Data Processing Pipeline

## Overview
This project creates a real-time data processing pipeline for ecommerce user activity using AWS services.

## Architecture
- **S3**: Raw data storage
- **Kinesis Data Streams**: Real-time data ingestion (2 streams)
- **AWS Glue**: Data cataloging and crawling
- **Lambda**: Stream processing and DynamoDB writes
- **DynamoDB**: Processed data storage
- **SNS**: High-severity incident notifications
- **Apache Flink**: Stream analytics and aggregation

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed
- Python 3.x for data simulation

## Deployment

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Deploy Infrastructure
```bash
terraform apply -auto-approve
```

### 3. Test Data Pipeline
```bash
python3 stream-data-app-simulation.py
```

## Resources Created
- S3 Bucket: `ecommerce-raw-pp-dev`
- Kinesis Streams: `ecommerce-raw-user-activity-pp-stream1/2`
- DynamoDB Table: `ddb-ecommerce-tab-1`
- Lambda Function: `ecommerce_lambda_function`
- SNS Topic: `ecommerce-high-severity-incidents`
- Glue Database: `db_ecommerce_raw`
- Glue Crawler: `ecommerce-user-activity-crawler`

## Cleanup
```bash
terraform destroy -auto-approve
```

## Files
- `s3.tf` - S3 bucket and sample data upload
- `data_stream.tf` - Kinesis data streams
- `glue_crawler.tf` - Glue database and crawler
- `lambda.tf` - Lambda function, DynamoDB, and SNS
- `studio_notebook.tf` - IAM roles for Kinesis Analytics
- `stream-data-app-simulation.py` - Data simulation script