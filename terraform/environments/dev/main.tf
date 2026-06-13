module "vpc" {
  source = "../../../modules/vpc"

  project_name = var.project_name

    vpc_cidr = var.vpc_cidr

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets

  availability_zones = var.availability_zones
}

module "eks" {
  source = "../../../modules/eks"

  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  ami_type           = var.ami_type

  instance_types = var.instance_type
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
}

module "security_groups" {
  source = "../../../modules/security-group"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source = "../../../modules/rds"

  project_name = var.project_name
  db_username  = var.db_username
  db_password  = random_password.db.result

  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
}


resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}

