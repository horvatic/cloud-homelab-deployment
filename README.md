# cloud-homelab-deployment
Homelab deployment to AWS.

## Overview 

This is a working example of deploying tasks, and services to ECS (fargate). Once deploy an API is created for each service in API Gateway.


This repo will:

On Deploy:
- Create the Cluster
- Create the Tasks
- Create the Services
- Create API's for the Services in API Gateway

On Destory:
- Delete the Cluster
- Delete the Tasks
- Delete the Services
- Delete the Services API's

The following is already created in AWS to use this example:
- A VPC
- A Subnet
- Security group
- A Private S3 Bucket