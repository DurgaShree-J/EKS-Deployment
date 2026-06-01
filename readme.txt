End-to-End DevOps Infrastructure & CI/CD on AWS (EKS):

Project Overview: 
This project demonstrates a complete DevOps pipeline implementing Infrastructure as Code (IaC), containerization, Kubernetes deployment, and CI/CD automation on AWS.

The application is a simple Flask service deployed on an AWS EKS cluster using Docker, Terraform, and GitHub Actions.

Architecture:
Developer
↓
GitHub Repository
↓
GitHub Actions CI/CD
↓
Docker Image Build
↓
AWS ECR (Container Registry)
↓
Amazon EKS Cluster
↓
Kubernetes Deployment + Service
↓
Application Access (Port-forward / Service)

AWS Infrastructure (Terraform):

Infrastructure Provisioning

All infrastructure is provisioned using Terraform.

Components Provisioned:

Networking:

Custom VPC
Two Public Subnets across multiple Availability Zones
Two Private Subnets across multiple Availability Zones
Internet Gateway
NAT Gateway
Route Tables and Route Associations

Compute
Amazon EKS Cluster
EKS Managed Node Group
IAM Roles and Policies

Database
Amazon RDS PostgreSQL
Security Group Restrictions
Private Network Placement

Security
Dedicated Security Groups
Principle of Least Privilege
Restricted Database Access

RDS PostgreSQL (not integrated in app yet)

Kubernetes Deployment (EKS):

Deployment:
•	Runs Flask application in pods 
•	2 replicas for high availability 

Service:
•	Exposes application using NodePort / ClusterIP 

Apply manifests:
kubectl apply -f k8s/
Access application:
kubectl port-forward svc/python-app-service 8080:80
Then open:
http://localhost:8080

AWS Authentication
AWS credentials are stored securely in GitHub Secrets:
•	AWS_ACCESS_KEY_ID 
•	AWS_SECRET_ACCESS_KEY 

Monitoring
•	Kubernetes: kubectl get pods 
•	Logs: kubectl logs <pod-name> 
•	AWS CloudWatch (optional for cluster logs/metrics) 

Security Considerations

Network Security

Private subnets for worker nodes
Restricted inbound access
Controlled outbound internet access through NAT Gateway
Database Security
PostgreSQL deployed within private networking
No public database access
Security Group-based access control
Secrets Management

AWS credentials are stored securely in GitHub Secrets:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

Future enhancement:
AWS Secrets Manager for database credential

Cost Optimization

Current Implementation:

Single NAT Gateway
Two Availability Zones
EKS Managed Node Group
Minimal worker node count

Future Improvements:

Scheduled scaling
Spot Instances
Log retention policies
Cluster Autoscaler


Current Implementation Summary

Implemented:

Terraform Infrastructure Provisioning
VPC with Public and Private Subnets
EKS Cluster
Managed Node Group
Security Groups
RDS PostgreSQL
Docker Containerization
Amazon ECR
GitHub Actions CI/CD
Kubernetes Deployment
Kubernetes Service
Terraform Remote State Management

Future Enhancements:
Full ALB Integration with Kubernetes Ingress
CloudWatch Container Insights
Prometheus and Grafana Monitoring
AWS Secrets Manager Integration
Multi-Environment Deployments
Cluster Autoscaling
Automated Backup Validation


Conclusion:
This project demonstrates an end-to-end DevOps implementation using Terraform, Docker, Kubernetes, GitHub Actions, Amazon ECR, Amazon EKS, and Amazon RDS while following Infrastructure as Code, CI/CD automation, security best practices, and scalable cloud-native deployment principles.
