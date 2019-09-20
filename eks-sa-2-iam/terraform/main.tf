provider "aws" {
  region = "ap-northeast-1" # Tokyo
}

locals {
  prefix       = "sa-to-iam"
  cluster_name = "${local.prefix}_main_eks"
  key_name     = "<your key pair>"
}
