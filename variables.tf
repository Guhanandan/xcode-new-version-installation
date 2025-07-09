variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-services"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "lambda_execution_role_arn" {
  type        = string
  description = "IAM role ARN for Lambda access"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "sample-function"
}

variable "mac_instance_name" {
  description = "Mac instance name"
  type        = string
  default     = "mac-instance"
}

variable "key_pair_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "sns_email" {
  description = "Email for SNS notifications"
  type        = string
}

variable "ws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}