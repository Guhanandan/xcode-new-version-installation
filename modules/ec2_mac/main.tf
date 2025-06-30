data "aws_ami" "mac" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ec2-macos-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "mac" {
  ami                    = data.aws_ami.mac.id
  instance_type          = "mac1.metal" # Mac instances require metal instance types
  key_name              = var.key_pair_name
  subnet_id             = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 200
    encrypted   = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.instance_name}"
    Environment = var.environment
    OS          = "macOS"
  }

  # Mac instances have specific requirements for tenancy
  tenancy = "host"
}