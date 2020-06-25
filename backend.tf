terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "ikenom-test3-terraform-state"
    key            = "terraform.tfstate"
    dynamodb_table = "ikenom-test3-terraform-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
