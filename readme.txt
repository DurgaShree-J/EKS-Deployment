Setup and Running the Infrastructure:
Prerequisites:
Ensure the following tools are installed:

Terraform
AWS CLI
kubectl
Docker
Git

Configure AWS credentials:
aws configure

Provide:
AWS Access Key ID
AWS Secret Access Key
AWS Region

Infrastructure Deployment
Navigate to the Terraform directory:
cd terraform

Initialize Terraform:
terraform init

Validate configuration:
terraform validate

Review planned changes:
terraform plan

Provision infrastructure:
terraform apply

The infrastructure provisions:
VPC
Public and Private Subnets
Internet Gateway
NAT Gateway
Security Groups
Amazon EKS Cluster
EKS Managed Node Group
Amazon RDS PostgreSQL
Application Load Balance

Configure Kubernetes Access
Update kubeconfig:

aws eks update-kubeconfig \
--region ap-south-1 \
--name <cluster-name>

Verify cluster connectivity:
kubectl get nodes

Deploy the Application
Deploy Kubernetes resources:
kubectl apply -f k8s/

Verify deployment:
kubectl get deployments
kubectl get pods
kubectl get svc

For local testing:
kubectl port-forward svc/python-app-service 8080:80

Access the application:
http://localhost:8080

Architecture Decisions:

Why Terraform?
Terraform was selected to implement Infrastructure as Code (IaC), enabling repeatable, version-controlled, and automated infrastructure provisioning.

Benefits:
Consistent deployments
Infrastructure versioning
Easy environment replication
Reduced manual configuration

Why Amazon EKS?
Amazon EKS was selected to manage containerized workloads using Kubernetes while reducing operational overhead.

Benefits:
Managed Kubernetes control plane
High availability
Scalability
Native AWS integration

Why Private Subnets for Worker Nodes?
EKS worker nodes are deployed in private subnets to reduce external exposure.

Benefits:
Improved security posture
Reduced attack surface
Controlled internet access through NAT Gateway

Why RDS PostgreSQL?
Amazon RDS PostgreSQL was selected to provide a managed relational database service.

Benefits:
Automated backups
Managed patching
High reliability
Reduced administrative effort

Why GitHub Actions?
GitHub Actions was selected to automate build, test, and deployment workflows.

Benefits:
Native GitHub integration
Automated CI/CD
Faster delivery cycles
Reduced manual deployment effort

Security Considerations:

The infrastructure follows a segmented network design:

Public subnets host internet-facing resources
Private subnets host worker nodes and database resources

This reduces direct exposure of critical components.

Security Groups:
Access is restricted using Security Groups:

Load Balancer accepts internet traffic
EKS worker nodes only accept required traffic
PostgreSQL accepts connections only from approved sources

Least Privilege IAM
IAM roles are configured using the principle of least privilege.

Only required permissions are granted to:
EKS Cluster
Node Groups
CI/CD Pipelines

Secure Credential Storage
Sensitive AWS credentials are not stored in source code.

Credentials are securely stored using GitHub Secrets:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

This prevents credential exposure and supports secure CI/CD execution.

Cost Optimization Measures:
Several cost optimization techniques were implemented.

Single NAT Gateway
A single NAT Gateway is used instead of one NAT Gateway per Availability Zone.

Benefit:
Lower infrastructure cost
Trade-off:
Reduced NAT high availability

Managed Node Group Sizing
Worker nodes are configured with a minimal node count suitable for application requirements.

Benefit:
Reduced EC2 costs
Efficient resource utilization

Multi-AZ Design with Minimal Resources
Resources are distributed across multiple Availability Zones while keeping infrastructure lightweight.

Benefit:
Improved availability
Controlled cost

Container-Based Deployment
Application workloads run as containers on Kubernetes.

Benefit:
Better resource utilization
Reduced operational overhead

Secret Management
The project implements secret management using GitHub Secrets.

The following sensitive values are stored securely:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

These secrets are consumed by GitHub Actions during CI/CD execution and are never committed to the repository.

Future enhancement:
AWS Secrets Manager for database credentials and application secrets.

_______________________________________________________________________

Current Implementation vs Production-Ready Design:

This project was completed within the assignment timeline and focuses on demonstrating Infrastructure as Code, container orchestration, and CI/CD automation.
The following sections describe the implemented solution and recommended production improvements.

Application Exposure
Current Implementation

The application is deployed to Amazon EKS using:
Kubernetes Deployment
Kubernetes Service (ClusterIP)

Application access is currently demonstrated using Kubernetes port forwarding:
kubectl port-forward svc/python-app-service 8080:80

Application URL:
http://localhost:8080

This approach was selected to simplify application validation during development and testing.

Production-Ready Approach:

For a production environment, the recommended architecture would be:

Internet
    |
Application Load Balancer (ALB)
    |
Kubernetes Ingress
    |
Service
    |
Application Pods

Benefits:

Public accessibility
TLS/HTTPS support
Load balancing
Better scalability
Centralized traffic management

An Application Load Balancer was provisioned through Terraform as part of the infrastructure layer. However, Kubernetes Ingress integration was not completed within the assignment timeline.

Monitoring - 
Current Implementation:

Application and cluster health are verified through Kubernetes operational commands:
kubectl get nodes
kubectl get pods
kubectl get deployments

Application logs are available through:
kubectl logs <pod-name>

This provides visibility into application status and deployment health.

Production-Ready Approach:

A production-grade monitoring solution would include:

Amazon CloudWatch Container Insights
Infrastructure metrics
Pod-level metrics
Node-level metrics
Database metrics
CloudWatch Dashboards

Key metrics:
CPU Utilization
Memory Utilization
Request Rate
Error Rate
Response Latency
Database Connections

Centralized Logging:
Current Implementation - 

Application logs are retrieved directly from Kubernetes:
kubectl logs <pod-name>

Operational troubleshooting is performed using:
kubectl describe pod <pod-name>
kubectl get events
Production-Ready Approach

A centralized logging architecture would include:

Application Pods
       |
    Fluent Bit
       |
CloudWatch Logs

Benefits:
Centralized log management
Log retention
Search and filtering
Alerting integration

Secrets Management:
Current Implementation- 

Sensitive AWS credentials are stored securely using GitHub Secrets:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

No credentials are stored directly in the source code repository.

Production-Ready Approach:

Additional secrets such as:
Database credentials
Application secrets
API keys
would be managed through AWS Secrets Manager.

Database Strategy:
Current Implementation - 

Amazon RDS PostgreSQL infrastructure has been provisioned through Terraform.
The sample Flask application is currently deployed independently and is not yet integrated with the PostgreSQL database.

Production-Ready Approach - 
The application would connect to RDS PostgreSQL using secure credentials stored in AWS Secrets Manager.

Database backups would be enabled through:
Automated backups
Point-in-time recovery
Snapshot retention policies

Network Architecture:
Current Implementation - 

Implemented:
Custom VPC
Public Subnets
Private Subnets
Internet Gateway
NAT Gateway
Security Groups
EKS Cluster
RDS PostgreSQL
Production-Ready Enhancements

Recommended additions:
One NAT Gateway per Availability Zone
VPC Flow Logs
Dedicated Database Subnets
VPC Endpoints
Network ACLs
WAF Integration
Route53 DNS Management

Summary:

The primary objective of this assignment was to demonstrate:

Infrastructure as Code using Terraform
Kubernetes deployment on Amazon EKS
Containerization using Docker
CI/CD automation using GitHub Actions
AWS cloud infrastructure provisioning

Where appropriate, production-grade enhancements have been documented to demonstrate how the solution would be extended in a real-world environment.
