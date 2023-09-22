locals {
  # Read global variables
  global = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  # Read environment variables
  environment = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # https://terragrunt.gruntwork.io/docs/features/locals/#including-globally-defined-locals
  # Currently you can only reference locals defined in the same config file.
  # Terragrunt does not automatically include locals defined in the parent config of an include block into the current context.
  project_name = local.environment.locals.project_name
  region       = local.global.locals.region
  zone         = local.global.locals.zones[0]
}

# Create remote state backend (it solves the chicken and egg problem for remote state)
remote_state {
  backend = "gcs"

  config = {
    project  = local.global.locals.devops_project
    location = local.global.locals.location
    bucket   = local.global.locals.tf_state_bucket
    prefix   = "${path_relative_to_include()}"

    gcs_bucket_labels = {
      owner = "terragrunt_test"
      name  = "terraform_state_storage"
    }
  }
}

# Keep backend configurations DRY
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "gcs" {
    bucket   = "${local.global.locals.tf_state_bucket}"
    prefix   = "${basename(get_terragrunt_dir())}"
  }
}
EOF
}

# Keep providers configuration DRY
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.environment.locals.project_name}"
  region  = "${local.region}"
  zone    = "${local.zone}"
}
provider "google-beta" {
  project = "${local.environment.locals.project_name}"
  region  = "${local.region}"
  zone    = "${local.zone}"
}
# Project details of the provider project
data "google_project" "project" {}
EOF
}

# GLOBAL PARAMETERS
# Configure root level variables that all resources can inherit. These variables apply to all configurations in this subfolder.
# These are automatically merged into the child `terragrunt.hcl` config via the include block. (see input block in dev/foo-app/bucket/terragrunt.hcl)
inputs = {
  project_id = local.project_name
}

terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "BEFORE HOOK: Running Terraform"]
  }

  after_hook "after_hook" {
    commands     = ["plan"]
    execute      = ["echo", "AFTER HOOK: Finished running Terraform"]
  }
}
