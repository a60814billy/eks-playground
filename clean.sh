#!/usr/bin/env bash

set +x

if [[ "$1" == "force" ]]; then
terraform destroy
fi

rm -rf ./.terraform
rm -rf ./.terraform.tfstate.lock.info
rm -rf ./terraform.tfstate.backup
rm -rf ./terraform.tfstate
