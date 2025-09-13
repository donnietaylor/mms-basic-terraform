# Demo 03: Azure Virtual Machine

## Overview
This demo creates a complete Linux Virtual Machine environment including networking components. It demonstrates complex resource relationships, security configurations, and VM deployment best practices.

## What This Demo Creates
- 1 Azure Resource Group
- 1 Virtual Network with subnet
- 1 Public IP address
- 1 Network Security Group with SSH and HTTP rules
- 1 Network Interface
- 1 Linux Virtual Machine (Ubuntu 22.04 LTS)
- Generated SSH key pair
- Generated admin password

## Prerequisites
- Azure CLI installed and configured
- Terraform installed (version >= 1.0)
- Azure subscription with appropriate permissions

## How to Run This Demo

1. Navigate to the terraform directory:
   ```bash
   cd demo-03-vm/terraform
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

5. Get connection information:
   ```bash
   terraform output ssh_connection_command
   terraform output -raw ssh_private_key > private_key.pem
   chmod 600 private_key.pem
   ```

6. Connect to the VM:
   ```bash
   ssh -i private_key.pem adminuser@<public_ip>
   ```

7. Clean up (destroy resources):
   ```bash
   terraform destroy
   ```

## Key Learning Points
- Virtual networking in Azure (VNet, Subnet)
- Network Security Groups and rules
- Public IP allocation
- VM configuration and sizing
- SSH key generation with Terraform
- Password generation for backup access
- Complex resource dependencies
- Sensitive outputs handling

## Security Features
- Network Security Group with limited access
- SSH key authentication (primary)
- Password authentication (backup)
- Private subnet with controlled public access

## Customization
You can customize the deployment by modifying variables:
- `location`: Change the Azure region (default: East US)
- `environment`: Change the environment tag (default: dev)
- `vm_size`: Change VM size (default: Standard_B2s)
- `admin_username`: Change admin username (default: adminuser)

Example with custom variables:
```bash
terraform apply -var="vm_size=Standard_D2s_v3" -var="admin_username=myuser"
```

## VM Specifications
- **OS**: Ubuntu 22.04 LTS
- **Default Size**: Standard_B2s (2 vCPUs, 4 GB RAM)
- **Storage**: Premium SSD
- **Network**: Public IP with SSH and HTTP access
- **Authentication**: SSH key + password backup