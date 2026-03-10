# AIRMAN Skynet Cloud Ops Intern Assessment — Submission Checklist

> Candidate: Fill this out and include it in your repository as `submission_checklist.md`

---

# 1) Candidate & Submission Info

* **Name:** Varun Madineni
* **Email:** varunmadineni13@gmail.com
* **Chosen Cloud Platform:** AWS
* **Assessment Level Submitted:** Level 1 + Level 2
* **Level 2 Option Chosen (if any):** Option B — CI/CD for Safe Cloud Deployments
* **GitHub Repo Link:** https://github.com/varunmadineni08/skynet-cloud-ops-assessment.git
* **Demo Video Link:** https://drive.google.com/file/d/1tV8rWFkGZjLZ1eBkksp6FmoRDsnN6Z5A/view?usp=drive_link
* **Submission Date (UTC):** 2026-03-11

---

# 2) What I Implemented (Summary)

## Level 1

* [x] Mini service (`/health`, `/events`, `/events`)
* [x] Dockerized service
* [x] Cloud deployment (real AWS deployment)
* [x] Infrastructure as Code (Terraform)
* [x] Cost optimization report
* [x] Observability setup (CloudWatch logging, metrics, alarms)
* [x] Security/secrets approach
* [x] Ops runbook
* [x] README with setup + teardown

---

## Level 2 (Optional)

* [ ] Option A — Automated Cost Guardrails
* [x] Option B — CI/CD for Safe Cloud Deployments
* [ ] Option C — SLOs + Error Budget + Ops Dashboard
* [ ] Option D — Multi-Environment Blueprint with Cost Governance

---

# 3) Repository Structure

## Service Code

* **Service path:** `/app`
* **Main entry file:** `app/main.py`
* **Local run command:** uvicorn app.main:app --host 0.0.0.0 --port 8000


# Docker

* **Dockerfile path:** `/Dockerfile`
* **.dockerignore path:** `/.dockerignore`

Docker build command: docker build -t audit-service .

Docker run command: docker run -p 8000:8000 audit-service


# Infrastructure as Code

* **IaC tool used:** Terraform
* **IaC root path:** `/infra`

Terraform resources provisioned:

* VPC
* Public Subnets
* Internet Gateway
* Route Tables
* Security Groups
* EC2 Instances
* Application Load Balancer
* Target Groups
* Listener
* Amazon ECR Repository

---

# Docs

* **README path:** `/README.md`
* **Cost report path:** `/docs/cost_estimate.md`
* **Runbook path:** `/docs/ops_runbook.md`
* **Observability notes/dashboard path:** `/docs/observability_monitoring.md`
* **Security/secrets notes path:** `/docs/security.md`
* **Limitations and Trade-offs:** `/docs/limitations.md`
* **IaC validation:** `/docs/iac_validation.md`
* **AI TOOl Usage Disclosure:** `/docs/ai_usage.md`


# Level 2 Implementation

## Level 2 Option Chosen

**Option B — CI/CD for Safe Cloud Deployments**

### Implementation Path

```
.github/workflows/ci.yml
```

### Pipeline Capabilities

The GitHub Actions pipeline performs the following steps automatically when code is pushed to the `main` branch:

1. Checkout repository
2. Setup Python runtime
3. Install service dependencies
4. Verify service imports
5. Build Docker image
6. Authenticate with AWS
7. Push Docker image to Amazon ECR
8. Validate Terraform infrastructure
9. Generate Terraform plan

This pipeline ensures that application changes are validated and container images are automatically published to ECR for deployment.

---

# 4) Local Run Instructions

## Prerequisites

* [x] Docker installed
* [x] Python 3.11 installed
* [x] Terraform installed
* [x] AWS CLI installed
* [x] AWS credentials configured

---

# Local Setup

Clone the repository:

```bash
git clone https://github.com/varunmadineni08/skynet-cloud-ops-assessment.git
cd YOUR_REPO
```

Install dependencies:

```bash
pip install -r requirements.txt
```

---

# Run Service Locally

Start the service using Python:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Or run using Docker:

```bash
docker build -t audit-service .
docker run -p 8000:8000 audit-service
```

---

# Test Endpoints Locally

Health check endpoint:

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

# Infrastructure Deployment

Navigate to Terraform directory:

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

Preview infrastructure changes:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply
```

After deployment, Terraform outputs the **Application Load Balancer DNS**, which can be used to access the deployed service.

Example:

```
http://<alb-dns>/health
```

---

# Infrastructure Teardown

To destroy all provisioned infrastructure:

```bash
terraform destroy
```

This removes:

* EC2 instances
* Load balancer
* Networking components
* Security groups
* Associated infrastructure

Note: CloudWatch logs or ECR images may persist unless explicitly deleted.

---


# Cloud Deployment Summary

## Deployment Type

* [x] Real cloud deployment
* [ ] IaC + mock/deploy plan only (not actually provisioned)

The service was deployed to **AWS using Terraform** to provision infrastructure resources.
The backend API container image is stored in **Amazon ECR** and executed on **EC2 instances**, with traffic routed through an **Application Load Balancer (ALB)**.

---

# Cloud Services Used

## Compute

* Amazon EC2 (t3.micro instances)
* Docker container runtime on EC2
* Instances run the containerized audit service application

---

## Storage / DB

* Application currently stores event data **in-memory (pilot-scale service)**
* Amazon ECR used for **container image storage**

---

## Networking / Ingress

* Amazon VPC
* Public Subnets
* Internet Gateway
* Route Tables
* Security Groups
* Application Load Balancer (ALB)
* Target Groups
* Health Checks

Traffic flow:

```
User → ALB → EC2 instances → Docker container
```

---

## Logging / Monitoring

* Amazon CloudWatch Logs
* Amazon CloudWatch Metrics
* CloudWatch Alarms
* CloudWatch Dashboard

Monitoring includes:

* CPU utilization
* ALB 5XX errors
* Health check signals

Application logs from containers are forwarded to **CloudWatch Log Groups** using the Docker awslogs driver.

---

## Secrets

* AWS IAM roles used for secure access
* No credentials stored in the repository
* Environment variables used for configuration

Example secure practices:

* `.env` files excluded via `.gitignore`
* `.env.example` provided for documentation

---

## Budgeting / Alerts

AWS cost-awareness practices implemented:

* CloudWatch alarms for monitoring abnormal behavior
* Minimal instance types used (`t3.micro`)
* Log retention policies configured

Cost target aligned with pilot guidance:

```
~$25–$75 per month
```

---

## Container Registry

* Amazon Elastic Container Registry (ECR)

Purpose:

* Store Docker images
* Enable EC2 instances to pull application images

Example image:

```
<aws_account_id>.dkr.ecr.<region>.amazonaws.com/audit-service-ecr-repo:latest
```

---

## IAM / Service Account

IAM roles used for:

* EC2 instances to pull images from ECR
* CloudWatch logging permissions

Security best practices followed:

* Principle of least privilege
* No hardcoded credentials

---

# Why I Chose This Architecture

1. **Simplicity for pilot deployment** — EC2 + Docker provides easy debugging and operational control.
2. **Cost efficiency** — small instance types and minimal infrastructure reduce idle spend.
3. **Load balancing** — ALB allows multiple instances for basic availability and scaling.
4. **Infrastructure reproducibility** — Terraform ensures consistent and repeatable deployments.
5. **Observability support** — CloudWatch integration provides logging and monitoring visibility.

---

# Pilot Cost-Awareness Notes

1. **Small instance sizes used** (`t3.micro`) to minimize compute costs.
2. **Minimal service footprint** — only essential resources deployed.
3. **Log retention kept short** to avoid unnecessary storage costs.
4. **Terraform destroy capability** allows complete environment teardown when not needed.
5. **Avoided managed database services** for the pilot phase to prevent unnecessary monthly charges.

This design balances **operational visibility, cost efficiency, and deployment simplicity**, which aligns with the **Skynet pilot environment requirements** described in the assessment.


# Notes for Reviewers

This project demonstrates a small-scale cloud deployment of an operational audit service designed for pilot environments. It focuses on:

* Cost-aware infrastructure choices
* Observability and monitoring fundamentals
* Infrastructure reproducibility via Terraform
* Containerized application deployment
* Operational documentation and runbooks
* CI pipeline for safe builds and infrastructure validation

The implementation aligns with the AIRMAN pilot-scale workload assumptions and prioritizes simplicity, cost control, and operational clarity.
