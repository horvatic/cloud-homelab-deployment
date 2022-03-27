# Cloud Homelab Deployment
Homelab deployment to AWS.

## Overview 

This is a working example of deploying tasks, and services to ECS (fargate). Once deploy an API is created for each service in API Gateway.


This repo will:

On Deploy:
- Create a Cluster
- Create the Tasks
- Create the Services
- Create API's for the Services in API Gateway

On Destory:
- Delete a Cluster
- Delete the Tasks
- Delete the Services
- Delete the Services API's

On Dev Deploy:
- Create a EC2 Ubuntu Machine

On Dev Destory:
- Delete a EC2 Ubuntu Machine

The following is already created in AWS to use this example:
- A VPC
- A Subnet
- Security group
- A Private S3 Bucket
