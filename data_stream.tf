resource "aws_kinesis_stream" "ecommerce_raw_user_activity1" {
  name = "ecommerce-raw-user-activity-pp-stream1"

  stream_mode_details {
    stream_mode = "ON_DEMAND" # Automatically scales based on traffic
  }

  retention_period = 24 # Data retention in hours (default is 24)

  tags = {
    Name        = "ecommerce-raw-user-activity-pp-stream1"
    Environment = "dev"
  }
}

resource "aws_kinesis_stream" "ecommerce_raw_user_activity2" {
  name = "ecommerce-raw-user-activity-pp-stream2"

  stream_mode_details {
    stream_mode = "ON_DEMAND" # Automatically scales based on traffic
  }

  retention_period = 24 # Data retention in hours (default is 24)

  tags = {
    Name        = "ecommerce-raw-user-activity-pp-stream2"
    Environment = "dev"
  }
}
