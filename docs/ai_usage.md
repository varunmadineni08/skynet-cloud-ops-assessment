# AI Tool Usage Disclosure

## AI Tools Used

The following AI tools were used during this assessment:

- ChatGPT

No other AI development assistants (Copilot, Cursor, Claude) were used.

---

## What AI Was Used For

AI assistance was primarily used for:

- clarifying assessment requirements
- structuring documentation files
- generating documentation templates (runbook, cost report, observability)
- improving explanation clarity in markdown documents
- reviewing architecture descriptions

AI was not used to automatically deploy infrastructure or generate
Terraform configurations without understanding the output.

---

## What Was Manually Implemented and Verified

All technical implementation and validation steps were performed manually.

This includes:

Infrastructure provisioning

- writing and running Terraform configurations
- creating VPC, subnets, EC2 instances, and ALB
- configuring security groups and networking

Container deployment

- building Docker images
- pushing images to Amazon ECR
- running containers on EC2 instances

Observability setup

- configuring Docker logging to CloudWatch
- creating log groups and log streams
- setting up CloudWatch metrics and alarms

Operational testing

- verifying service endpoints
- testing ALB traffic routing
- validating health checks
- generating test traffic and verifying logs

Infrastructure validation

- running terraform init
- running terraform validate
- running terraform plan
- running terraform apply
- testing terraform destroy

All infrastructure behavior and system functionality were verified
through manual testing in the AWS environment.

---

## Summary

AI tools were used primarily for documentation support and conceptual
clarification. All infrastructure deployment, configuration, testing,
and validation were performed manually.