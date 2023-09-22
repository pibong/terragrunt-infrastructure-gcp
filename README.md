# Terragrunt example for GCP
A Terragrunt example to layout folders and modules in a Google Cloud Platform project.
This is a real production-ready example, but you can change the folders/moduleslayout based on your requirements and needs.

This layout is trying to make both code and confirations **really DRY**.
It is also solving a common chicken and egg problem: "how can I apply code with a remote state without having the remote backend in place?" --> `remote_state` block in `live/global.hcl`.

A brief overview on files in this repo:
- `live/global.hcl` contains global parameters (e.g region, location, common prefixes, ..)
- `live/terragrunt.hcl` centrally defines backend configurations, provider(s) definition, backend creation, global parameters
- `live/_envcommon` folder sets the common resources needed among all environments (dev and prod)
- `live/dev/environment.hcl` defines environment specific parameters

Code is self-explanatory, please read comments in hcl files.

## How to use repository 

### pre-commit initialization
To format the code in this repo I use [pre-commit](https://pre-commit.com/). You can install the tool with `pip` or `brew`:

```sh
# Install with pip
pip install pre-commit

# Install with brew
brew install pre-commit
```

Once installed you need to configure the cloned repo to use the versioned configuration:

```sh
pre-commit install
```

For further information read the upstream documentation.


### Configure Terraform authentication

Read Terraform documentation for [Google provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication) as a reference.

### Set your GCP project IDs
Replace placeholders in:
- [live/global.hcl](https://github.com/pibong/terragrunt-infrastructure-gcp/blob/main/live/global.hcl#L9)
- [live/dev/environment.hcl](https://github.com/pibong/terragrunt-infrastructure-gcp/blob/main/live/dev/environment.hcl#L4)
- [live/prod/environment.hcl](https://github.com/pibong/terragrunt-infrastructure-gcp/blob/main/live/prod/environment.hcl#L4)

### Deploy a single module in an environment

```sh
cd infrastructure/gcp/dev/buckets
terragrunt plan -out=terragrunt.plan
terragrunt apply terragrunt.plan
```

### Deploy all modules within an environment

```sh
cd infrastructure/gcp/dev
terragrunt run-all --terragrunt-no-auto-approve apply
```
