terraform {
    backend "s3" {
        bucket = "state-file-terraform-code"
        key = "dev/terraform.tfstate"
        region = "us-east-1"
        use_lockfile = true    
    }
}