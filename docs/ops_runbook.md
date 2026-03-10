# Skynet Ops Audit Service – Operations Runbook

## Purpose

This runbook describes the operational procedures required to monitor,
troubleshoot, and maintain the Skynet Ops Audit Service deployed on AWS.

The deployment was created as part of the AIRMAN Cloud Ops Intern assessment
and represents a pilot-scale environment.

Infrastructure provisioning was performed using Terraform, and application
containers are deployed on EC2 instances using Docker.

This runbook provides steps to diagnose and resolve common operational
scenarios such as service outages, latency spikes, cost anomalies, and
configuration errors.

---

# System Architecture Overview

The system is deployed inside an AWS Virtual Private Cloud (VPC) and uses
a simple high-availability architecture.

Main components:

- AWS VPC
- Public subnets across two availability zones
- Application Load Balancer (ALB)
- EC2 instances running Docker containers
- Amazon ECR container registry
- CloudWatch Logs and Metrics
- Terraform Infrastructure as Code

---

# VPC Architecture

The infrastructure is deployed inside a dedicated VPC to isolate network
resources.

The VPC contains:

- 2 public subnets
- security groups controlling traffic
- EC2 instances placed across both subnets

This multi-subnet setup improves availability and distributes traffic across
multiple availability zones.

Future production improvements could include:

- private subnets for application servers
- NAT gateway for outbound internet access
- bastion host for SSH access.

---

# Container Image Repository (Amazon ECR)

The Skynet Ops Audit Service container image is stored in Amazon Elastic
Container Registry (ECR).

Repository example:

audit-service-ecr-repo

Deployment workflow:

1. Application is packaged into a Docker image
2. Image is pushed to ECR
3. EC2 instances pull the image from ECR
4. Containers are started using the Docker runtime

Example command used:

docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/audit-service-ecr-repo:latest

This approach ensures a centralized and version-controlled container image
repository.

---

# Traffic Flow

Client requests follow this path:

Internet  
→ Application Load Balancer  
→ Target Group  
→ EC2 Instances  
→ Docker Container (Audit Service)

The load balancer distributes requests across the EC2 instances and performs
health checks to ensure service availability.

---

# Monitoring and Observability

Observability is implemented using Amazon CloudWatch.

Logging:

Docker containers send logs to CloudWatch Logs using the awslogs logging
driver.

Log group example:

skynet-ops-audit-service

Monitoring:

CloudWatch metrics track:

- EC2 CPU utilization
- ALB request count
- ALB latency
- ALB HTTP error rates

Alerts:

CloudWatch alarms are configured to detect abnormal conditions such as:

- high load balancer latency
- high 5xx error rates

---

# Infrastructure Management

All infrastructure resources are managed using Terraform.

Terraform manages:

- VPC
- Subnets
- Security groups
- EC2 instances
- Application Load Balancer
- Target groups

Deployment command:

terraform apply

Teardown command:

terraform destroy

Using Infrastructure as Code ensures the environment can be reproduced
consistently.