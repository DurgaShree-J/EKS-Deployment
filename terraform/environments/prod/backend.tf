terraform {
  backend "s3" {
    bucket       = "state-file-terraform-code-2"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}