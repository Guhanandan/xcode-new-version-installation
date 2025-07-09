ws_region   = "us-west-2"
environment  = "dev"
project_name = "xcode-new-version-update"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
availability_zones   = ["us-west-2a", "us-west-2b"]

# Service Configuration
s3_bucket_name        = "xcode-app-downloads"
lambda_function_name  = "xcode-lambda-function"
mac_instance_name     = "xcode-mac-instance"
key_pair_name         = ""
sns_email            = ""
email_address = "your-email@example.com"

