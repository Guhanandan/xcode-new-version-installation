resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  #acl    = "private"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# test feature: S3 bucket access policy. jus trying it as a feature
# S3 Bucket Policy to allow Lambda functions to put and get Xcode binaries
resource "aws_s3_bucket_policy" "xcode_binaries_policy" {
  bucket = aws_s3_bucket.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow CloudWatch to write logs to the bucket
      {
        Action    = "s3:PutObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.main.arn}/*"
        Principal = "*"
        Condition = {
          StringLike = {
            "aws:RequestTag/Source" = "cloudwatch"
          }
        }
      },
      # Allow Lambda to put the Xcode binaries to the bucket
      {
        Action    = "s3:PutObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.main.arn}/*"
        Principal = "*"
        Condition = {
          StringLike = {
            "aws:RequestTag/Source" = "lambda"
          }
        }
      },
      # Allow Lambda to read from the S3 bucket (download binaries)
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.main.arn}/*"
        Principal = "*"
        Condition = {
          StringLike = {
            "aws:RequestTag/Source" = "lambda"
          }
        }
      }
    ]
  })
}