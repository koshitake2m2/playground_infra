# GCE

## Setup

```bash
cd envs
cp env_vars.hcl.sample dev/env_vars.hcl
vim dev/env_vars.hcl
```

## Tips in Local

```bash
# apply
cd envs/dev
terragrunt run-all apply

# ssh
gcloud compute ssh web-server
```

## Tips in Instance

```bash
# Check the logs of metadata_startup_script.
sudo journalctl -u google-startup-scripts.service
```
