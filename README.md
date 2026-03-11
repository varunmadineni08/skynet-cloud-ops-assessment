# Skynet Audit Service — Cloud Ops Assessment

This repository contains my submission for the **AIRMAN Skynet Cloud Ops Intern Technical Assessment**.

The project demonstrates how a small backend service can be **containerized, deployed to the cloud, monitored, and managed using Infrastructure as Code and CI pipelines** while maintaining cost awareness suitable for pilot-scale environments.

---

# Project Overview

This project implements a **simple audit event service** with endpoints to record and retrieve events. The service is containerized using Docker and deployed on AWS infrastructure provisioned via Terraform.

The architecture uses **two EC2 instances behind an Application Load Balancer**, allowing traffic distribution and basic fault tolerance.

The project also includes **observability, cost awareness, CI automation, and operational documentation**.

---

# Service Endpoints

| Endpoint  | Method | Description            |
| --------- | ------ | ---------------------- |
| `/health` | GET    | Service health check   |
| `/events` | POST   | Store an audit event   |
| `/events` | GET    | Retrieve stored events |

Example request:

```bash
curl -X POST http://localhost:8000/events \
-H "Content-Type: application/json" \
-d '{"event_type":"login","message":"User logged in"}'
```

---

# Architecture Overview

The service is deployed using the following AWS architecture:

```
User
  │
  ▼
Application Load Balancer
  │
  ├── EC2 Instance (Docker container)
  │
  └── EC2 Instance (Docker container)
```

Infrastructure components:

* Amazon VPC
* Public subnets
* Internet Gateway
* Security groups
* EC2 instances
* Application Load Balancer
* Target groups
* Amazon ECR
* CloudWatch monitoring

---

# Technology Stack

| Component          | Technology                |
| ------------------ | ------------------------- |
| Backend            | Python (FastAPI)          |
| Containerization   | Docker                    |
| Infrastructure     | Terraform                 |
| Cloud Platform     | AWS                       |
| Compute            | EC2                       |
| Container Registry | Amazon ECR                |
| Load Balancing     | Application Load Balancer |
| Monitoring         | CloudWatch                |
| CI Pipeline        | GitHub Actions            |

---

# Repository Structure

```
repo
│
├── app/                     # Service source code
│   └── main.py
    └── models.py
|   └── mstorage.py
│
├── infra/
|   ├── main.tf
|   ├── providers.tf
|   ├── variables.tf         # Infrastructure as Code
│
├── docs/                    # Project documentation
│   ├── cost_estimate.md
│   ├── observability_monitoring.md
│   ├── security.md
│   ├── ops_runbook.md
|   ├── iac_validation.md
|   ├── workload_assumptions.md
|   ├── limitations.md
|   ├── ai_usage.md
│
├── .github/workflows/       # CI pipeline
│   └── ci.yml
│
├── Dockerfile
├── requirements.txt
├── README.md
└── submission_checklist.md
```

---

# Running the Service Locally

## Prerequisites

* Python 3.11
* Docker
* Git

---

## Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git](https://github.com/varunmadineni08/skynet-cloud-ops-assessment.git
cd YOUR_REPO
```

---

## Install Dependencies

```bash
pip install -r requirements.txt
```

---

## Run the Service

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

---

## Test Endpoints

Health check:

```bash
curl http://localhost:8000/health
```

Create event:

```bash
curl -X POST http://localhost:8000/events \
-H "Content-Type: application/json" \
-d '{"event_type":"test","message":"sample event"}'
```

Retrieve events:

```bash
curl http://localhost:8000/events
```

---

# Running with Docker

Build the container image:

```bash
docker build -t audit-service .
```

Run the container:

```bash
docker run -p 8000:8000 audit-service
```

The service will be available at:

```
http://localhost:8000
```

---

# Cloud Deployment

Infrastructure is provisioned using **Terraform**.

Resources created:

* VPC
* Public subnets
* Internet gateway
* Route tables
* Security groups
* EC2 instances
* Application Load Balancer
* Target groups
* Amazon ECR repository

---

# Deploy Infrastructure

Navigate to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Preview changes:

```bash
terraform plan
```

Apply deployment:

```bash
terraform apply
```

After deployment, Terraform outputs the **ALB DNS name** which can be used to access the service.

Example:

```
http://<alb-dns>/health
```

---

# Container Deployment

The service container image is stored in **Amazon ECR**.

Example image:

```
<aws-account-id>.dkr.ecr.<region>.amazonaws.com/audit-service-ecr-repo:latest
```

EC2 instances pull this image and run the service container.

---

# Observability & Monitoring

Monitoring is implemented using **Amazon CloudWatch**.

Features:

* CloudWatch Logs for container logs
* CloudWatch Metrics for infrastructure
* CloudWatch alarms for system health
* Monitoring dashboard

Metrics monitored:

* CPU utilization
* 5XX error responses
* Health check signals

---

# CI Pipeline

A GitHub Actions workflow is implemented to automate service validation and container publishing.

Pipeline tasks:

1. Checkout repository
2. Setup Python environment
3. Install dependencies
4. Validate application imports
5. Build Docker image
6. Authenticate with AWS
7. Push container image to Amazon ECR
8. Run Terraform validation
9. Generate Terraform plan

Workflow file:

```
.github/workflows/ci.yml
```

---

# Security Practices

The project follows basic cloud security practices:

* IAM roles used for EC2 permissions
* No credentials stored in the repository
* GitHub Actions secrets used for CI authentication
* Security groups restrict inbound traffic
* Sensitive configuration excluded via `.gitignore`

---

# Cost Awareness

This project was designed for **pilot-scale environments**.

Cost control strategies:

* Small EC2 instance types (`t3.micro`)
* Minimal infrastructure footprint
* Log retention policies
* Ability to destroy infrastructure via Terraform

Estimated monthly cost:

```
~$25–$75 depending on usage
```

---

# Teardown / Cleanup

To remove all deployed infrastructure:

```bash
cd terraform
terraform destroy
```

This removes:

* EC2 instances
* Load balancer
* Networking components
* Security groups

Note: ECR images and CloudWatch logs may persist unless manually deleted.

---

# Future Improvements

Possible enhancements for production deployments:

* HTTPS using AWS Certificate Manager
* Auto Scaling Groups
* Private subnets for compute instances
* Centralized secrets management
* Full CI/CD deployment automation

---

# Assessment Scope

This project fulfills the **AIRMAN Cloud Ops Intern assessment requirements**, demonstrating:

* Cloud infrastructure provisioning
* Containerized service deployment
* Monitoring and observability
* Cost awareness
* Security practices
* CI pipeline implementation
* Operational documentation

---

# Author

**Varun Madineni**

Cloud Ops Intern Assessment Submission
