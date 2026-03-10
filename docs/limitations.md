# Known Limitations and Trade-offs

This section documents important limitations of the current pilot
implementation of the Skynet Ops Audit Service and potential
improvements for future iterations.

The current design prioritizes simplicity and cost efficiency
appropriate for a pilot deployment.

---

## 1. Instances Deployed in Public Subnets

Current design:

EC2 instances are deployed in public subnets to simplify access
and container image pulling.

Limitation:

This exposes instances to the public internet (even though access
is restricted using security groups).

Future improvement:

Move application instances into private subnets and use:

- NAT Gateway for outbound internet access
- Bastion host or SSM Session Manager for administration.

---

## 2. No HTTPS / TLS Termination

Current design:

The Application Load Balancer accepts traffic over HTTP (port 80).

Limitation:

Traffic between clients and the load balancer is not encrypted.

Future improvement:

Enable HTTPS using:

- AWS Certificate Manager (ACM)
- ALB HTTPS listener on port 443.

This would provide encrypted communication.

---

## 3. Limited Auto Scaling

Current design:

Two EC2 instances are manually provisioned.

Limitation:

The system does not automatically scale in response to traffic
changes.

Future improvement:

Use an Auto Scaling Group to:

- automatically add instances during traffic spikes
- reduce instances during low traffic periods.

This would improve both availability and cost efficiency.

---

## 4. No Managed Database or Persistent Storage

Current design:

The service currently uses simple local storage for events.

Limitation:

Data persistence and durability are limited.

Future improvement:

Integrate a managed storage backend such as:

- Amazon RDS
- DynamoDB
- Amazon S3

This would improve durability and scalability.

---

## 5. Basic Monitoring Only

Current design:

Monitoring includes:

- CloudWatch metrics
- CloudWatch alarms
- CloudWatch logs

Limitation:

Observability is limited to basic metrics and logs.

Future improvement:

Introduce advanced monitoring tools such as:

- distributed tracing
- application performance monitoring (APM)
- log aggregation and analytics tools.

---


## 6. Limited Security Hardening

Current design:

Basic security measures are implemented:

- IAM roles
- security groups
- restricted ports

Limitation:

Advanced security protections are not implemented.

Future improvement:

Enhance security by adding:

- AWS WAF
- private subnet architecture
- secrets management using AWS Secrets Manager.

---

## 7. Limited Cost Automation

Current design:

Cost monitoring relies on manual review and CloudWatch alerts.

Limitation:

Cost control mechanisms are limited.

Future improvement:

Implement automated cost guardrails such as:

- AWS Budgets alerts
- scheduled instance shutdown for non-production environments
- automated cleanup of unused resources.