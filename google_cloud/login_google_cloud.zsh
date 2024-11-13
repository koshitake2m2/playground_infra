#!/bin/zsh
# Please execute in current shell instead sub shell. Current shell has a session.
# e.g. source ~/koshitake2m2/playground_infra/google_cloud/login_google_cloud.zsh

# 1. Apply environments.
echo "$(dirname $0)/.env"
echo
cat "$(dirname $0)/.env"
echo
source "$(dirname $0)/.env"


gcloud auth login
gcloud auth application-default login
