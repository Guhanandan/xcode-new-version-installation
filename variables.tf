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

variable "email_address" {
  description = "Email address to receive Xcode version update notifications"
  type        = string
  
  validation {
    condition     = can(regex("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", var.email_address))
    error_message = "Must be a valid email address."
  }
}

variable "sns_topic_name" {
  description = "Name for the SNS topic"
  type        = string
  default     = "xcode-version-updates"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.sns_topic_name))
    error_message = "SNS topic name must contain only letters, numbers, hyphens, and underscores."
  }
}

variable "ssm_parameter_name" {
  description = "Name for the SSM parameter storing the current Xcode version"
  type        = string
  default     = "/xcode/latest_version"
}

variable "lambda_execution_role_arn" {
  type        = string
  description = "IAM role ARN for Lambda access"
  sensitive   = true
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
  sensitive   = true
}

variable "sns_email" {
  description = "Email for SNS notifications"
  type        = string
  sensitive   = true
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Lambda"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for Lambda"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "Security group ID for Lambda function"
  type        = string
}

variable "ec2_security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

