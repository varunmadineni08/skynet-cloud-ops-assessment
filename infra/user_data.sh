#!/bin/bash

# update packages
apt update -y

# install docker
apt install -y docker.io

# start docker
systemctl start docker
systemctl enable docker

# allow ubuntu user to run docker
usermod -aG docker ubuntu

# install aws cli
apt install -y awscli

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# login to ECR
aws ecr get-login-password --region eu-north-1 \
| docker login \
--username AWS \
--password-stdin <ACCOUNT_ID>.dkr.ecr.eu-north-1.amazonaws.com

# pull docker image
docker pull <ACCOUNT_ID>.dkr.ecr.eu-north-1.amazonaws.com/audit-service:latest

# run container
docker run -d -p 8000:8000 \
--name audit-service \
<ACCOUNT_ID>.dkr.ecr.eu-north-1.amazonaws.com/audit-service:latest