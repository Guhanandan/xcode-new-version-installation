# AWS Infrastructure with Terraform Modules

This repository contains a comprehensive Terraform configuration for deploying AWS infrastructure using a modular approach. The infrastructure includes VPC networking, EC2 Mac instances, S3 storage, Lambda functions, and CloudWatch monitoring.

## 🏗️ Architecture Overview

The infrastructure consists of the following components:

- **VPC Module**: Multi-AZ Virtual Private Cloud with public and private subnets
- **EC2 Mac Module**: macOS virtual machine for development/testing
- **S3 Module**: Secure object storage bucket with encryption
- **Lambda Module**: Serverless function with VPC integration
- **CloudWatch Module**: Monitoring and alerting system

## 📁 Project Structure

```
project/
├── main.tf                     # Root configuration
├── variables.tf                # Root variables
├── outputs.tf                  # Root outputs
├── terraform.tfvars            # Variable values (create this)
├── README.md                   # This file
└── modules/
    ├── vpc/
    │   ├── main.tf             # VPC resources
    │   ├── variables.tf        # VPC variables
    │   └── outputs.tf          # VPC outputs
    ├── s3/
    │   ├── main.tf             # S3 resources
    │   ├── variables.tf        # S3 variables
    │   └── outputs.tf          # S3 outputs
    ├── lambda/
    │   ├── main.tf             # Lambda resources
    │   ├── variables.tf        # Lambda variables
    │   └── outputs.tf          # Lambda outputs
    ├── ec2_mac/
    │   ├── main.tf             # EC2 Mac resources
    │   ├── variables.tf        # EC2 variables
    │   └── outputs.tf          # EC2 outputs
    └── cloudwatch/
        ├── main.tf             # CloudWatch resources
        ├── variables.tf        # CloudWatch variables
        └── outputs.tf          # CloudWatch outputs
```

## 🚀 Quick Start

### Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **EC2 Key Pair** created in your target AWS region
4. **Unique S3 bucket name** (globally unique across all AWS accounts)

### Installation Steps

1. **Clone or create the project structure** as shown above

2. **Create terraform.tfvars file** with your specific values:
```hcl
aws_region   = "us-west-2"
environment  = "dev"
project_name = "my-aws-project"

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
availability_zones   = ["us-west-2a", "us-west-2b"]

# Service Configuration
s3_bucket_name        = "your-unique-bucket-name-12345"
lambda_function_name  = "sample-function"
mac_instance_name     = "mac-instance"
key_pair_name         = "your-existing-key-pair"
sns_email            = "alerts@yourdomain.com"
```

3. **Initialize Terraform**:
```bash
terraform init
```

4. **Plan the deployment**:
```bash
terraform plan
```

5. **Apply the configuration**:
```bash
terraform apply
```

6. **Confirm SNS email subscription** (check your email)

## 📋 Module Details

### VPC Module (`modules/vpc/`)

Creates a robust networking foundation with:

**Resources Created:**
- VPC with DNS support
- Internet Gateway
- Public subnets (2) with auto-assign public IP
- Private subnets (2) for secure resources
- NAT Gateways (2) for private subnet internet access
- Route tables and associations
- Security groups for EC2 and Lambda

**Security Groups:**
- **EC2 Security Group**: SSH (22), VNC (5900)
- **Lambda Security Group**: Outbound access only

**Outputs:**
- VPC ID
- Subnet IDs (public and private)
- Security Group IDs

### S3 Module (`modules/s3/`)

Creates a secure S3 bucket with:

**Features:**
- Server-side encryption (AES256)
- Versioning enabled
- Public access blocked
- Proper tagging

**Outputs:**
- Bucket name
- Bucket ARN

### Lambda Module (`modules/lambda/`)

Deploys a serverless function with:

**Features:**
- Python 3.9 runtime
- VPC integration for secure communication
- S3 access permissions
- Environment variables
- Sample code for S3 operations

**IAM Permissions:**
- VPC access execution role
- S3 read/write permissions
- CloudWatch logs access

**Outputs:**
- Function name
- Function ARN

### EC2 Mac Module (`modules/ec2_mac/`)

Deploys macOS virtual machine with:

**Specifications:**
- **Instance Type**: mac1.metal (dedicated hardware)
- **AMI**: Latest Amazon macOS AMI
- **Storage**: 200GB encrypted GP3 volume
- **Tenancy**: Dedicated host (required for Mac)

**⚠️ Important Notes:**
- Mac instances are expensive (~$25/hour minimum)
- Require 24-hour minimum billing
- Limited availability in some regions
- Need dedicated host allocation

**Outputs:**
- Instance ID
- Public IP address
- Private IP address

### CloudWatch Module (`modules/cloudwatch/`)

Implements comprehensive monitoring with:

**Alarms Created:**
Alarms need to be created


## 🔧 Configuration Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `s3_bucket_name` | Unique S3 bucket name | `my-app-bucket-12345` |
| `key_pair_name` | Existing EC2 key pair | `my-keypair` |
| `sns_email` | Email for alerts | `admin@company.com` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-west-2` |
| `environment` | Environment name | `dev` |
| `project_name` | Project identifier | `xcode-new-version-update` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |

## 💰 Cost Considerations

### Estimated Monthly Costs (us-west-2)

| Service | Configuration | Estimated Cost |
|---------|---------------|----------------|
| **Mac EC2** | mac1.metal (24/7) | ~$1,800/month |
| **VPC** | NAT Gateways (2) | ~$90/month |
| **Lambda** | 1M invocations | ~$0.20/month |
| **S3** | 100GB storage | ~$2.30/month |
| **CloudWatch** | Basic monitoring | ~$3/month |

**Total Estimated Cost: ~$1,895/month**

⚠️ **Cost Warning**: The Mac EC2 instance is the most expensive component. Consider using it only when needed.

## 🔒 Security Features

### Network Security
- Private subnets for sensitive resources
- Security groups with minimal required access
- VPC isolation

### Data Security
- S3 bucket encryption at rest
- EBS volume encryption
- Public access blocked on S3

### Access Control
- IAM roles with least privilege
- No hardcoded credentials
- Resource-based policies


### CloudWatch



#### Adding Security Group Rules
Edit `modules/vpc/main.tf`:
```hcl
resource "aws_security_group" "ec2" {
  # Add new ingress rule
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Environment-Specific Configurations

Create multiple `.tfvars` files:
- `dev.tfvars`
- `staging.tfvars`
- `prod.tfvars`

Deploy with:
```bash
terraform apply -var-file="prod.tfvars"
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Mac Instance Launch Failures
**Error**: "Insufficient capacity"
**Solution**: 
- Try different availability zones
- Use regions with Mac capacity (us-east-1, us-west-2, eu-west-1)
- Contact AWS support for dedicated host allocation

#### 2. S3 Bucket Name Conflicts
**Error**: "BucketAlreadyExists"
**Solution**: Use a globally unique bucket name with random suffix

#### 3. Lambda VPC Timeouts
**Error**: Lambda function timeout in VPC
**Solution**: 
- Ensure NAT Gateway is properly configured
- Check security group rules
- Verify route table associations

#### 4. Key Pair Not Found
**Error**: "InvalidKeyPair.NotFound"
**Solution**: Create the key pair in AWS Console first

### Debug Commands

```bash
# Validate configuration
terraform validate

# Show current state
terraform show

# List resources
terraform state list

# Destroy specific resource
terraform destroy -target=module.ec2_mac
```

## 🔄 Management Operations

### Updating Infrastructure

1. **Modify configuration files**
2. **Plan changes**:
```bash
terraform plan
```
3. **Apply updates**:
```bash
terraform apply
```

### Backup State

```bash
# Backup state file
cp terraform.tfstate terraform.tfstate.backup

# Use remote state (recommended)
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "infrastructure/terraform.tfstate"
    region = "us-west-2"
  }
}
```

### Destroying Infrastructure

```bash
# Destroy all resources
terraform destroy

# Destroy specific module
terraform destroy -target=module.ec2_mac
```

## 📚 Additional Resources

### Terraform Documentation
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Modules](https://www.terraform.io/docs/language/modules/index.html)

### AWS Documentation
- [EC2 Mac Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-mac-instances.html)
- [VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/)

### Best Practices
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
