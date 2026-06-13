variable "common_tags" {
  type = map(string)
}

variable "bucket_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "force_destroy" {
  type = bool
}

variable "object_lock_enabled" {
  type = bool
}

variable "versioning_status" {
  type = string
  validation {
    condition = contains(["Enabled","Disabled","Suspended"],
    var.versioning_status
    )
    error_message = "Versioning status must be Enabled, Suspended or Disabled"
  }
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "enable_public_access_block" {
  default = true
}