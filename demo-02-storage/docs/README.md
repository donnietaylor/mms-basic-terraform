# Demo 02: Azure Storage Account

## Overview
This demo builds upon Demo 01 by adding Azure Storage Account resources. It demonstrates resource dependencies, the random provider, and storage configuration options.

## What This Demo Creates
- 1 Azure Resource Group
- 1 Azure Storage Account (with random suffix for uniqueness)
- 1 Storage Container (private access)

## Prerequisites
- Azure CLI installed and configured
- Terraform installed (version >= 1.0)
- Azure subscription with appropriate permissions

## How to Run This Demo

1. Navigate to the terraform directory:
   ```bash
   cd demo-02-storage/terraform
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
- Resource dependencies (storage account depends on resource group)
- Using the random provider for unique naming
- Storage account configuration options
- Storage container creation
- Variable validation
- Multiple outputs

## Customization
You can customize the deployment by modifying variables:
- `location`: Change the Azure region (default: East US)
- `environment`: Change the environment tag (default: dev)
- `storage_account_tier`: Standard or Premium (default: Standard)
- `storage_replication_type`: LRS, GRS, RAGRS, or ZRS (default: LRS)

Example with custom variables:
```bash
terraform apply -var="location=West US 2" -var="storage_account_tier=Premium" -var="storage_replication_type=ZRS"
```

## Storage Account Features Demonstrated
- Unique naming with random suffix
- Configurable tier and replication
- Private container creation
- Proper tagging strategy