output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  value       = module.sns.topic_arn
}

output "ssm_parameter_name" {
  description = "Name of the SSM parameter storing the current Xcode version"
  value       = module.ssm.parameter_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.lambda.function_arn
}

output "mac_instance_ip" {
  description = "Mac instance public IP"
  value       = module.ec2_mac.public_ip
}

# output "cloudwatch_alarm_arn" {
#   description = "CloudWatch alarm ARN"
#   value       = module.cloudwatch.alarm_arn
# }