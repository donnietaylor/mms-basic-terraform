# Demo 01: Basic Azure Resource Group

## Overview
This is the most basic Terraform demo for MMSMusic conference. It demonstrates the fundamental concepts of Terraform by creating a single Azure Resource Group.

## What This Demo Creates
- 1 Azure Resource Group with appropriate tags

## Prerequisites
- Azure CLI installed and configured
- Terraform installed (version >= 1.0)
- Azure subscription with appropriate permissions

## How to Run This Demo

1. Navigate to the terraform directory:
   ```bash
   cd demo-01-basic/terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. Clean up (destroy resources):
   ```bash
   terraform destroy
   ```

## Key Learning Points
- Basic Terraform structure (main.tf, variables.tf, outputs.tf)
- Azure provider configuration
- Resource Group creation
- Variable usage
- Output values
- Resource tagging best practices

## Customization
You can customize the deployment by modifying variables:
- `location`: Change the Azure region (default: East US)
- `environment`: Change the environment tag (default: dev)

Example with custom variables:
```bash
terraform apply -var="location=West US 2" -var="environment=prod"
```