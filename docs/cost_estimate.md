# Skynet Ops Audit Service – Cost Optimization Report

Purpose:

This document estimates the monthly cloud cost for running the Skynet Ops Audit
Service pilot deployment and explains the cost control strategies used.

The goal is to keep the infrastructure within the expected pilot budget:

$25 – $75 per month

while maintaining sufficient observability and reliability.

---

--> Cost Estimate Summary

| Component          | Service                   | Estimated Monthly Cost |
| ------------------ | ------------------------- | ---------------------- |
| Compute            | EC2 (2 × t3.micro)        | ~$16                   |
| Load Balancing     | Application Load Balancer | ~$16                   |
| Storage            | EBS volumes               | ~$2                    |
| Container Registry | ECR storage               | ~$1                    |
| Logging            | CloudWatch Logs           | ~$2                    |
| Monitoring         | CloudWatch metrics/alarms | ~$1                    |
| Data transfer      | ALB + EC2 traffic         | ~$2                    |


Estimated Monthly Total: ~$40 / month

AWS Monthly Cost Table:
[Download Excel](https://1drv.ms/x/c/bb67e6ba3def5aed/IQBU_a5sx_GxRJmhUy6g-KfzAUFXqc0f5ADryRrqKdMhA_A?e=68iG9Y)

This stays within the target budget range of $25–$75 for the pilot system.



Assumptions Used for Cost Estimate:

These estimates are based on the workload assumptions defined in
`workload_assumptions.md`.

Traffic assumptions:

5,000 – 20,000 API requests per day

Payload assumptions:

POST /events payload size: 0.5 KB – 5 KB  
GET /events responses: 5 KB – 40 KB

Data growth assumptions:

200 – 2,000 events per day

Monthly raw storage estimate:

10 MB – 250 MB

Log retention policy:

7–14 days for pilot environment.

---

Component-wise Cost Breakdown

--> EC2 Compute

Instances used:

2 × t3.micro instances

Estimated cost:

~$8 per instance per month  
Total: ~$16/month

Reason for choice:

t3.micro provides sufficient CPU and memory for the pilot workload while keeping
cost low.

---

--> Application Load Balancer

Used to distribute traffic between both EC2 instances.

Estimated cost:

~$16/month

Includes:

- Load balancer hourly cost
- Load balancer capacity units (LCU)

ALB also provides health checks and improves availability.

---

--> EBS Storage

Each EC2 instance has a small root volume.

Estimated:

8–10 GB per instance

Estimated cost:

~$1 per instance per month  
Total: ~$2/month

---

--> Container Registry (ECR)

Docker images are stored in Amazon ECR.

Estimated storage:

~150 MB image

Estimated cost:

~$1/month

---

--> CloudWatch Logs

Application logs are sent from Docker containers to CloudWatch Logs.

Estimated log volume:

~1–2 GB/month

Estimated cost:

~$2/month

---

--> CloudWatch Monitoring

Includes:

- CloudWatch metrics
- CloudWatch alarms
- Dashboard widgets

Estimated cost:

~$1/month

---

--> Data Transfer

Traffic between ALB and EC2 and external requests.

Estimated cost:

~$2/month

Pilot environment traffic is low, so data transfer costs remain minimal.

---

Cost Controls Implemented / Proposed

--> Budgets

AWS Budgets can be configured to monitor spending.

Example budget:

$75 monthly budget

Alerts will trigger if spending exceeds:

50% threshold  
80% threshold  
100% threshold

---

--> Billing Alerts

Billing alerts notify the team if unexpected spending occurs.

Example alerts:

- Monthly spend exceeds $50
- Monthly spend exceeds $75

Alerts are sent through CloudWatch or email notifications.

---

--> Resource Tags for Cost Tracking

Resources are tagged for cost visibility.

Example tags:

Environment = pilot  
Project = skynet  
Owner = cloud-ops

These tags allow filtering cost reports in AWS Cost Explorer.

---

--> Log Retention Policy

CloudWatch logs are configured with limited retention to avoid
unnecessary storage costs.

Retention strategy:

Dev logs: 3–7 days  
Pilot logs: 7–14 days

Old logs are automatically deleted after the retention period.

---

--> Non-Production Shutdown Strategy

To reduce costs:

Development environments may be stopped outside working hours.

Possible automation:

- Scheduled EC2 stop/start
- Lambda scheduler
- Auto scaling scale-to-zero (future improvement)

---

--> Cleanup Strategy (TTL)

Temporary resources should not remain active indefinitely.

Cleanup practices:

- Remove unused Docker images
- Delete unused EBS volumes
- Remove old CloudWatch log groups
- Delete unused ECR images

Lifecycle policies can automatically remove old images from ECR.

---

Teardown Instructions:

The infrastructure is deployed using Terraform.

To destroy all resources:

terraform destroy

This command removes:

VPC  
EC2 instances  
Load balancer  
Target groups  
Security groups

Running destroy prevents unnecessary ongoing charges.

---

Common AWS Cost Traps Accounted For

The following common cloud cost risks were considered during the design.

1. Idle EC2 instances running continuously
2. Large overprovisioned instance types
3. Excessive CloudWatch log retention
4. Unused EBS volumes left attached
5. Old container images accumulating in ECR
6. Load balancers left running after testing
7. Unnecessary data transfer between regions
8. NAT gateways generating hourly costs
9. Snapshots accumulating without cleanup
10. Debug-level logging generating large log volumes

These risks were mitigated by using small instances, limited log retention,
and clear teardown procedures.