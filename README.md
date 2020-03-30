# EKS playground setup

This git repository provides terraform configuration to create EKS cluster with metrics-server and kubernetes dashboard.

## Requirements

- AWS IAM user that can create aws resources
- AWS CLI
- Terraform >= 0.12

## How to use?

### Setup EKS cluster

The `init_env.sh` script is going to modify your AWS CLI setting. You must backup your AWSCLI setting before run it.
The AWS CLI setting is store under `$HOME/.aws` directory.

```bash
AWS_ACCESS_KEY=xxxxxx AWS_SECRET_KEY=xxxxxx ./init_env.sh
```

### Destroy EKS environment

The `clean.sh` script is used clean AWS resources and terraform state. If you doesn't want to clean AWS resources, just ignore `force` parameter. 

```bash
./clean.sh force
```