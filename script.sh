#!/bin/bash
# Initialize the Terraform working directory
rm -r .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup apply.out apply.copy > /dev/null 2>&1

terraform init -reconfigure

# Format the configuration files
terraform fmt

# Validate the configuration files
terraform validate

# Create an execution plan
terraform plan

# Apply the changes required to reach the desired state of the configuration
terraform apply -auto-approve  > apply.out  # Automatically approve the apply action

./vmid.sh

rm -r .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup  > /dev/null 2>&1
