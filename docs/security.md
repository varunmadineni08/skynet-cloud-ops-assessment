# Security Practices – Skynet Ops Audit Service

## Purpose

This document describes the security practices used for the Skynet Ops Audit
Service pilot deployment.

The goal is to apply safe cloud defaults and reduce common security risks while
keeping the system simple and cost-efficient.

---

# Identity and Access Management (IAM)

Access to AWS services is controlled using AWS IAM roles.

The EC2 instances running the application are assigned an IAM role that allows
the container to write logs to CloudWatch Logs.

Permissions granted to the EC2 instance role include:

- CloudWatch Logs: CreateLogStream
- CloudWatch Logs: PutLogEvents

Using IAM roles avoids storing AWS credentials directly on the server.

No long-lived AWS access keys are stored in the application or repository.

---

# Secrets Management

Sensitive information should not be committed to source control.

To enforce this practice:

- Secrets are not stored inside the Git repository
- Environment variables are used to configure sensitive values
- A `.env.example` file can be provided to document required variables

Example environment variables:

PORT=
APP_ENV=
LOG_LEVEL=
STORE_BACKEND=
MAX_EVENTS_LIMIT=
SERVICE_NAME=

The actual `.env` file should remain local and excluded using `.gitignore`.

## Network Security

The Skynet Ops Audit Service infrastructure is deployed inside an AWS VPC to
provide network isolation and control.

### VPC Architecture

The deployment uses a dedicated Virtual Private Cloud (VPC) with multiple
subnets to separate infrastructure resources.

Components include:

- 1 VPC
- 2 public subnets (different availability zones)
- EC2 instances deployed across both subnets
- Application Load Balancer acting as the entry point

This architecture improves availability and distributes traffic across
multiple zones.

---

### Traffic Flow

External clients access the service through the Application Load Balancer.

Traffic path:

Internet  
→ Application Load Balancer (ALB)  
→ Target Group  
→ EC2 instances running the audit service container

The load balancer performs health checks and distributes requests between
instances.

---

### Security Groups

Security groups are used as virtual firewalls to control inbound and outbound
traffic.

Two main security groups are used.

Application Load Balancer Security Group

Inbound rules:

Port 80 (HTTP)  
Source: 0.0.0.0/0

This allows public access to the application through the load balancer.

Outbound rules:

Allow traffic to EC2 instances on application port.

---

EC2 Instance Security Group

Inbound rules:

Port 8000  
Source: Application Load Balancer Security Group

Port 22 (SSH)  
Source: administrator IP address

Outbound rules:

Allow outbound internet access for pulling container images and sending logs
to CloudWatch.

This configuration ensures that the application port is not directly exposed
to the public internet.

---

### Port Usage

The following ports are used in the deployment.

| Port | Purpose |
|-----|--------|
| 80 | HTTP traffic from internet to ALB |
| 8000 | Application service inside EC2 |
| 22 | SSH access for instance administration |


### Health Checks

The Application Load Balancer performs health checks on the service using:

GET /health

Healthy instances remain in the load balancer target group and continue to
serve traffic.

Unhealthy instances are automatically removed from rotation.


# Instance Security

EC2 instances follow several baseline security practices.

These include:

- SSH access using key-based authentication
- No password-based SSH login
- Minimal installed packages
- System packages updated regularly

Example update command used during setup:

sudo apt update
sudo apt upgrade -y

---

# Container Security

The application is packaged using Docker containers.

Security considerations include:

- Using trusted base images
- Avoiding unnecessary software inside the container
- Running a single service per container

The container does not store AWS credentials or secrets.

Logs are forwarded to CloudWatch using the Docker awslogs driver.

---

# Logging and Monitoring

Application logs are centralized using Amazon CloudWatch Logs.

Each EC2 instance sends container logs to a CloudWatch log group.

Benefits include:

- centralized log visibility
- easier troubleshooting
- security event auditing

CloudWatch alarms are configured to detect issues such as:

- high load balancer latency
- high 5xx error rates

These alarms help detect service failures quickly.

---

# Data Protection

The pilot environment does not store sensitive personal data.

However, several good practices are followed:

- API access controlled via the load balancer
- limited network exposure through security groups
- structured logging for auditability

Future improvements may include:

- HTTPS with TLS certificates
- AWS Secrets Manager for sensitive credentials
- private subnets for application instances

---

# Security Limitations (Pilot Environment)

Because this deployment represents a pilot environment, some advanced security
controls are not implemented to avoid unnecessary complexity and cost.

Examples include:

- WAF protection
- full private subnet architecture
- advanced secret rotation

These features may be added in a production environment.

---

# Summary

The system follows several baseline security practices:

- IAM roles instead of static credentials
- restricted security group rules
- key-based SSH authentication
- centralized logging through CloudWatch
- environment variable-based configuration

These controls provide a secure baseline suitable for a pilot deployment while
maintaining operational simplicity.

# Future Security Improvements

In a production environment, additional network security controls could include:

- Moving EC2 instances into private subnets
- Restricting SSH access through a bastion host
- Enabling HTTPS with TLS certificates
- Adding AWS WAF for protection against web attacks
- Using NAT Gateway for controlled outbound internet access
