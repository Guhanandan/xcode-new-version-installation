terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment         = var.environment
  project_name        = var.project_name
}

# S3 Module
module "s3" {
  source = "./modules/s3"
  
  bucket_name  = var.s3_bucket_name
  environment  = var.environment
  project_name = var.project_name
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"
  
  function_name     = var.lambda_function_name
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.vpc.lambda_security_group_id
  s3_bucket_name    = module.s3.bucket_name
  environment       = var.environment
  project_name      = var.project_name
}

# EC2 Mac Module
module "ec2_mac" {
  source = "./modules/ec2_mac"
  
  instance_name     = var.mac_instance_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.ec2_security_group_id
  key_pair_name     = var.key_pair_name
  environment       = var.environment
  project_name      = var.project_name
}

# CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"
  
  lambda_function_name = module.lambda.function_name
  ec2_instance_id      = module.ec2_mac.instance_id
  s3_bucket_name       = module.s3.bucket_name
  sns_email            = var.sns_email
  environment          = var.environment
  project_name         = var.project_name
}
