variable "aws_region" {
  type = string
}
variable "db_username" {
    type = string
}

variable "project_name" {
    type = string
}

variable "vpc_cidr" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "instance_type" {
  type    = list(string)
}

variable "cluster_name" {
     type = string
}

variable "ami_type" {
  type = string
}

variable "db_username" {
  type = string
}

variable "public_subnets" {
  type    = list(string)
}

variable "private_subnets" {
  type    = list(string)
}

variable "availability_zones" {
  type    = list(string)
}

variable "db_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}