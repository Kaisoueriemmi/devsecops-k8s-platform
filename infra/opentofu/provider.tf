# Fournisseur AWS pointé sur Floci : aucun compte ni appel vers le vrai AWS.
provider "aws" {
  region     = var.region
  access_key = "test"
  secret_key = "test"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  endpoints {
    s3             = var.floci_endpoint
    sqs            = var.floci_endpoint
    kms            = var.floci_endpoint
    iam            = var.floci_endpoint
    sts            = var.floci_endpoint
    dynamodb       = var.floci_endpoint
    secretsmanager = var.floci_endpoint
  }
}
