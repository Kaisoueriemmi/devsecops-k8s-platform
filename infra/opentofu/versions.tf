terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # État dans un bucket S3 de Floci, verrou dans une table DynamoDB (INF-03).
  # Le bucket et la table sont créés une fois par scripts/tofu-bootstrap.sh.
  # L'adresse de Floci est passée à l'init : tofu init -backend-config=backend.hcl
  backend "s3" {
    bucket         = "tofu-state"
    key            = "platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tofu-lock"

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
