provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

# Create IAM Role with AdministratorAccess policy
resource "aws_iam_role" "ec2_role" {
  name = "ec2-admin-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# Attach AdministratorAccess policy to the IAM Role
resource "aws_iam_role_policy_attachment" "admin_access_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_role.name
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2_admin_role_profile"

  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "api_instance" {
  ami           = "ami-0230bd60aa48260c6" # Amazon Linux 2 AMI
  instance_type = "t2.micro" # Change this to your desired instance type
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              yum install pip -y
              $(aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 645262066647.dkr.ecr.us-east-1.amazonaws.com)
              sudo docker pull 645262066647.dkr.ecr.us-east-1.amazonaws.com/ontra:latest
              sudo docker run -d -p 8080:8080 645262066647.dkr.ecr.us-east-1.amazonaws.com/ontra:latest
              EOF
}

resource "aws_security_group" "api_security_group" {
  name        = "api_security_group"
  description = "Allow inbound traffic on port 8080"
  
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_ip" {
  value = aws_instance.api_instance.public_ip
}