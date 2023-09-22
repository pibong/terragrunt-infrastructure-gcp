# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the env common configuration for the component. The env common configuration contains settings that are common
# for the component across all environments.
include "base" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/buckets.hcl"
}

# No `inputs` block because we don't want to override common configurations defined in `_envcommon/buckets.hcl`