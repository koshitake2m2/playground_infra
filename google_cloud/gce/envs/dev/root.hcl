locals {
  variables   = read_terragrunt_config(find_in_parent_folders("env_vars.hcl"))
  project_name = local.variables.locals.project_name
}
