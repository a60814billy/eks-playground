#!/bin/bash

set -euo pipefail
set -x

DEFAULT_ACCESS_KEY=""
DEFAULT_SECRET_KEY=""

region="us-east-1"
access_key="${AWS_ACCESS_KEY:=$DEFAULT_ACCESS_KEY}"
access_secret="${AWS_SECRET_KEY:=$DEFAULT_SECRET_KEY}"

cat > ~/.aws/config <<EOL
[default]
region = ${region}
EOL

cat > ~/.aws/credentials <<EOL
[default]
aws_access_key_id = ${access_key}
aws_secret_access_key = ${access_secret}
EOL

sed -i "" -E "s/aws_access_key = \".*\"/aws_access_key = \"${access_key}\"/g" ./terraform.tfvars
sed -i "" -E "s~aws_secret_key = \".*\"~aws_secret_key = \"${access_secret}\"~g" ./terraform.tfvars

terraform init

terraform apply -auto-approve -target=module.vpc
terraform apply -auto-approve -target=module.cluster
terraform apply -auto-approve -target=module.worker1
terraform apply -auto-approve
