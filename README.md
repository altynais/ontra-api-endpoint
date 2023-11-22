# Deploying API Endpoint on AWS

This repository contains code and configuration to deploy a simple API endpoint on AWS.

## Prerequisites

Make sure you have the following tools installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://www.docker.com/get-started)

## Deployment Steps

1. Clone this repository:

   ```bash
   git clone https://github.com/altynais/ontra-api-endpoint.git

2. Create AWS ECR repository

    export AWS_ACCESS_KEY_ID="your-access-key"
    export AWS_SECRET_ACCESS_KEY="your-secret-key"
    aws ecr create-repository --repository-name <repository-name>
    aws ecr get-login-password --region <aws-region> | docker login --username AWS --password-stdin <ecr-repository-uri>


3. Build image and push to aws registry

    cd ontra-api-endpoint/api
    docker build -t <image_name> .
    docker tag <image_name>:latest <ecr-repository-uri>/<image_name>:latest
    docker push <ecr-repository-uri>/<image_name>:latest

4. Terraform init and apply

    terraform init
    terraform apply




    Destoy resources:

        terraform destroy


