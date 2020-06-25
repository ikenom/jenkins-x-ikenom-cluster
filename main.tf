provider "aws" {}

variable "cluster_namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "terraform_state_backend" {
  source        = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=master"
  namespace     = var.cluster_namespace
  stage         = var.cluster_name
  name          = "terraform"
  attributes    = ["state"]
  region        = "us-east-1"
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy = true
}

module "eks-jx" {
  source  = "jenkins-x/eks-jx/aws"
  cluster_name = var.cluster_name
  force_destroy = true
  enable_logs_storage = true
  enable_reports_storage = true
  enable_repository_storage = true
}

output "vault_user_id" {
  value       = module.eks-jx.vault_user_id
  description = "The Vault IAM user id"
}

output "vault_user_secret" {
  value       = module.eks-jx.vault_user_secret
  description = "The Vault IAM user secret"
}
