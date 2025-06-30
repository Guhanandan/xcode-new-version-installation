data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.project_name}-${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name        = "${var.project_name}-${var.environment}-lambda-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda.name
}

data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name   = "${var.project_name}-${var.environment}-lambda-s3-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source {
    content = <<EOF
import json
import boto3

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    
    # Example S3 operation
    s3 = boto3.client('s3')
    bucket_name = '${var.s3_bucket_name}'
    
    try:
        response = s3.list_objects_v2(Bucket=bucket_name, MaxKeys=10)
        object_count = response.get('KeyCount', 0)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Successfully processed event. S3 bucket {bucket_name} has {object_count} objects.',
                'event': event
            })
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "main" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-${var.environment}-${var.function_name}"
  role            = aws_iam_role.lambda.arn
  handler         = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "python3.9"
  timeout         = 30

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
      ENVIRONMENT    = var.environment
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.function_name}"
    Environment = var.environment
  }
}