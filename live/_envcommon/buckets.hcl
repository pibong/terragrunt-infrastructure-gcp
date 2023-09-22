locals {
  # Read common defined variables
  global_vars      = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # https://terragrunt.gruntwork.io/docs/features/locals/#including-globally-defined-locals
  # Currently you can only reference locals defined in the same config file.
  # Terragrunt does not automatically include locals defined in the parent config of an include block into the current context.
  shared_modules_url = local.global_vars.locals.shared_modules_url
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = "${local.shared_modules_url}/terraform-google-cloud-storage?ref=v3.4.1"
}

dependency "sa" {
  config_path = "${get_terragrunt_dir()}/../service-accounts"
}


# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
inputs = {
  # This module require `project_id` as mandatory variable, but it is inherited (merged) from the terragrunt.hcl file
  prefix     = local.global_vars.locals.bucket_prefix
  names      = ["common"]
  admins     = ["serviceAccount:${dependency.sa.outputs.email}"]
}

