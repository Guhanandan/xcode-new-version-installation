output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.mac.id
}

output "public_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.mac.public_ip
}

output "private_ip" {
  description = "EC2 instance private IP"
  value       = aws_instance.mac.private_ip
}