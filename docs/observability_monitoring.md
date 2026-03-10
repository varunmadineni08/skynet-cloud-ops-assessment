# Observability & Monitoring – Skynet Ops Audit Service

## Purpose

This document describes the logging, monitoring, and alerting mechanisms
implemented for the Skynet Ops Audit Service.

Observability is critical for understanding system health, detecting failures,
and diagnosing operational issues during the pilot deployment.

The monitoring stack uses AWS CloudWatch for logs, metrics, dashboards,
and alerts.

---

# Logging

## Structured Logs

The application generates logs in structured format to make them easier
to search and analyze.

Example log output from the audit service container:

2026-03-10T10:12:20Z INFO request_received endpoint=/events method=POST
2026-03-10T10:12:20Z INFO event_saved event_id=812
2026-03-10T10:12:21Z INFO request_completed status=200 latency_ms=45

Structured logs allow filtering by:

- request type
- endpoint
- response status
- latency

---

## Log Collection

Application logs are collected using Docker's awslogs logging driver.

Each container sends logs directly to Amazon CloudWatch Logs.

Example container configuration used during deployment:

docker run -d \
-p 8000:8000 \
--log-driver=awslogs \
--log-opt awslogs-region=eu-north-1 \
--log-opt awslogs-group=skynet-ops-audit-service \
--log-opt awslogs-stream=instance-1 \
audit-service-ecr-repo

---

## Log Groups

CloudWatch log group used:

skynet-ops-audit-service

Log streams:

instance-1  
instance-2

These log streams correspond to the EC2 instances running the service.

---

## Log Level Configuration

The logging level can be controlled through environment variables.

Example:

LOG_LEVEL=INFO

Possible levels:

DEBUG  
INFO  
WARN  
ERROR

Using configurable log levels prevents excessive logging in production
environments while still allowing deeper debugging when required.

---

# Metrics

System performance and traffic metrics are collected using AWS CloudWatch.

The following metrics are monitored.

---

## Request Latency

Metric Source:

Application Load Balancer

Metric Name:

TargetResponseTime

Purpose:

Measures how long requests take to be processed by backend instances.

Used to detect performance degradation.

---

## Error Rate

Metric Source:

Application Load Balancer

Metric Name:

HTTPCode_Target_5XX_Count

Purpose:

Counts server-side errors returned by the service.

High values may indicate application failures or backend issues.

---

## Traffic Volume

Metric Source:

Application Load Balancer

Metric Name:

RequestCount

Purpose:

Tracks the number of incoming requests handled by the system.

Helps understand usage patterns and detect unusual traffic spikes.

---

## Health Signal Monitoring

The Application Load Balancer performs health checks on backend instances.

Health check endpoint:

GET /health

Healthy instances remain active in the load balancer target group.

Unhealthy instances are automatically removed from request routing.

---

# Alerts

CloudWatch alarms are configured to notify operators when abnormal
conditions occur.

---

## Alert #1 – High ALB Latency

Metric:

TargetResponseTime

Threshold:

> 2 seconds for multiple evaluation periods

Rationale:

Typical latency is expected to remain below 1 second.
A sustained latency above 2 seconds may indicate resource contention,
application performance issues, or backend failures.

Action:

Investigate EC2 CPU usage and container performance.

---

## Alert #2 – High 5xx Error Rate

Metric:

HTTPCode_Target_5XX_Count

Threshold:

More than 5 errors within a monitoring interval.

Rationale:

Server-side errors indicate that requests are failing.
This alert helps detect service outages quickly.

Action:

Check container logs and verify application health.

---

# CloudWatch Dashboard

A CloudWatch dashboard is used to visualize system metrics.

Dashboard widgets include:

- ALB request count
- ALB response time
- EC2 CPU utilization
- ALB 5xx error count

This dashboard provides a centralized view of service health.

---

# Monitoring Configuration

Monitoring configuration includes:

CloudWatch Logs

- Docker container logs forwarded using awslogs driver
- Centralized log group: skynet-ops-audit-service
- Separate log streams per instance

CloudWatch Metrics

- ALB metrics automatically collected
- EC2 CPU metrics monitored

CloudWatch Alarms

Configured alerts include:

- high latency alert
- high 5xx error alert

CloudWatch Dashboard

A dashboard aggregates key metrics for quick monitoring of system health.

---

# Evidence (Screenshots)

The following screenshots are included in the repository to demonstrate
the monitoring setup.

screenshots/Cloudwatch-log-group.png  
screenshots/Cloudwatch-log-1.png  
screenshots/Cloudwatch-log-2.png  
screenshots/Cloudwatch-Dashboard.png  
screenshots/Cloudwatch-alarms.png

These screenshots provide visual confirmation that logging, metrics,
and alerting have been configured correctly.

---

# Summary

The Skynet Ops Audit Service implements basic observability practices
suitable for a pilot deployment.

Implemented features include:

- centralized structured logging
- request latency monitoring
- error rate tracking
- traffic volume metrics
- automated health checks
- CloudWatch alarms for service issues
- monitoring dashboards

These capabilities allow operators to quickly detect and troubleshoot
system issues.