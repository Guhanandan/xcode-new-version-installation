variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Lambda"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for Lambda"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}