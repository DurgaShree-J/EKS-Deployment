variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
  default = "1.29"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "instance_types" {
  type    = list(string)
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  # default = 3
}

variable "min_size" {
  type    = number
  default = 1
}

variable "ami_type" {
  type = string
}