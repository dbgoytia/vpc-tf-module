# Lock terraform version
terraform {
  required_version = "0.13.5"
}

# S3 backend configuration
terraform {
  backend "s3" {
    bucket = "691e4876-f921-0542-c9c7-0989c184fe8c-backend"
    key    = "networks"
    region = "us-east-1"
  }
}
