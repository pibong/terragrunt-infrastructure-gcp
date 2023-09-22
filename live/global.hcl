locals {
  region             = "europe-west8"
  zones              = ["europe-west8-b", "europe-west8-c", "europe-west8-a"]
  location           = "eu"
  default_zone       = local.zones[0]
  shared_modules_url = "git@github.com:terraform-google-modules"
  bucket_prefix      = "terragrunt-example-pb-gcs"
  sa_prefix          = "tg-example-pb-sa"
  devops_project     = "<GCP_DEVOPS_PROJECT>"
  tf_state_bucket    = "${local.bucket_prefix}-tf-state"
}
