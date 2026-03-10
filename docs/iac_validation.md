# Infrastructure as Code (IaC) Validation & Reproducibility

## Purpose

This document describes how the infrastructure for the Skynet Ops Audit Service
is provisioned, validated, and destroyed using Terraform.

Infrastructure as Code ensures that the environment can be reliably recreated
by any operator using the same configuration files.

All cloud infrastructure components were provisioned using Terraform.

---

# Terraform Components

The Terraform configuration provisions the following AWS resources:

- Virtual Private Cloud (VPC)
- Public subnets (2)
- Internet Gateway
- Route tables
- Security groups
- EC2 instances (application servers)
- Application Load Balancer (ALB)
- Target group
- Load balancer listener

These components together provide the infrastructure required to run the
Skynet Ops Audit Service container.

---

# Terraform Initialization

Before applying infrastructure, Terraform must initialize the working directory.

Command used:

terraform init

Purpose:

- Downloads required Terraform providers
- Initializes backend configuration
- Prepares the directory for Terraform operations

Successful execution confirms that the Terraform configuration is ready.

---

# Terraform Validation

Terraform configuration syntax is validated using:

terraform validate

Purpose:

- checks configuration syntax
- verifies resource definitions
- detects configuration errors before deployment

Expected output:

Success! The configuration is valid.

---

# Terraform Plan

Infrastructure changes are previewed using:

terraform plan

Purpose:

- shows which resources will be created
- verifies configuration correctness
- prevents unintended infrastructure changes

Example output includes resources such as:

- aws_vpc
- aws_subnet
- aws_instance
- aws_lb
- aws_lb_target_group

Reviewing the plan ensures that only expected resources are created.

---

# Terraform Apply

Infrastructure is deployed using:

terraform apply

This command creates all defined AWS resources including:

- VPC
- subnets
- security groups
- EC2 instances
- load balancer
- target group

After deployment completes, the system becomes accessible via
the Application Load Balancer DNS endpoint.

---

# Variables

Terraform variables allow infrastructure configuration to be customized.

Example variables used in the deployment include:

region

AWS region where infrastructure is deployed.

instance_type

Defines EC2 instance type used for application servers.

Example value:

t3.micro

vpc_cidr

CIDR block for the VPC network.

Example:

10.0.0.0/16

public_subnet_cidrs

CIDR ranges for the public subnets.

Example:

10.0.1.0/24  
10.0.2.0/24

Variables are defined in:

variables.tf

and values can be provided through:

terraform.tfvars


# Infrastructure Teardown

To destroy all infrastructure resources created by Terraform, run:

terraform destroy

Terraform will display a list of resources that will be removed.

After confirmation, Terraform deletes:

- EC2 instances
- load balancer
- target groups
- security groups
- VPC resources

This ensures that no unnecessary cloud resources remain running.

---

# Resource Cleanup Considerations

Most infrastructure resources are removed during terraform destroy.

However, some AWS services may retain data depending on configuration.

Examples include:

CloudWatch Logs

Log groups may retain logs based on configured retention policies.

ECR Images

Container images stored in ECR may remain unless manually deleted
or managed with lifecycle policies.


Operators should verify these resources after infrastructure teardown
to ensure no unnecessary storage costs remain.

---

# Reproducibility Summary

The infrastructure deployment process is fully reproducible using Terraform.

Steps required to recreate the environment:

1. clone repository
2. run terraform init
3. run terraform validate
4. run terraform plan
5. run terraform apply

To remove all infrastructure:

terraform destroy

Using Infrastructure as Code ensures consistent, repeatable deployments
and reduces the risk of configuration drift.