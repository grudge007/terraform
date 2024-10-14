#!/bin/bash
terraform init -reconfigure
terraform fmt
terraform validate
terraform plan
terraform apply
