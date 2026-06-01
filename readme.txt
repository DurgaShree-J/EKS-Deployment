Current Implementation
1. Single NAT Gatway (Cost optimized)
2. 2 AZ high availability
3. Public and Private Subnet

For Production Improvement
1. One NAT gateway per AZ
2. VPC Flow Logs
3. Separate DB subnets
4. VPC Endpoints (s3, dynamodb)
5. NACL


Security Design:
ALB Exposed to internet only
EKS only accessible via ALB SG
RDS only accessible from EKS SG
No public db exposure


For simplicity, a single environment is provisioned.
Separate dev/staging/prod environments can be created by 
supplying different tfvars files and backend keys.