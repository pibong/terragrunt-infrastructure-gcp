# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the env common configuration for the component. The env common configuration contains settings that are common
# for the component across all environments.
include "base" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/buckets.hcl"
  merge_strategy = "deep"
}

inputs = {
  # We need to add an access role to a dataset defined in the parent
  # file (_envcommon/bucket.hcl) just for this environment. To
  # achieve this we used the `deep` merge strategy, so we can easily
  # manage this type of stuff. The defalut merge strategy is `shallow`:
  # to achieve the same result with that configuration we need to
  # redefine the entire names list here and maintain two different
  # lists.
  names = ["foo"]
}
