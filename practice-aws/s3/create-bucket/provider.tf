provider "aws" {
  region                      = var.region
  s3_force_path_style = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    s3                       = "http://aws:4566"
  }
}
