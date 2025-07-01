# Add your variable definitions here

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "ec2_instance_id" {
  description = "ID of the EC2 Mac instance"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "sns_email" {
  description = "SNS email address for notifications"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}