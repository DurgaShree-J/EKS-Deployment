module "vpc" {
  source = "../modules/vpc"

  project_name = "assignment"

  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}

module "eks" {
  source = "../modules/eks"

  cluster_name        = "startup-eks"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  ami_type = "AL2023_x86_64_STANDARD"

  instance_types = ["t3.medium"]
}

module "security_groups" {
  source = "../modules/security-group"

  project_name = "assignment"
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source = "../modules/rds"

  project_name       = "assignment"
  db_username        = "propone"
  db_password        = random_password.db.result

  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
}


resource "random_password" "db" {
  length  = 16
  special = true
  override_special  = "!#$%&*()-_=+[]{}:?"
}