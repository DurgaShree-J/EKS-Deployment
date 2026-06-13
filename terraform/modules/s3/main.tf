resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags = merge(
     var.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  count  = var.enable_public_access_block ? 1 : 0  #if true, then 1 or false = 0, which means if 0 means then its disables public access and does not create this resource block.
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
#   bucket = aws_s3_bucket.mybucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykey.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }