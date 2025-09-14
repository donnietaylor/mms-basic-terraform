# Demo 2: Windows Virtual Machine Deployment

## Overview
This demo shows how to deploy a complete Windows virtual machine infrastructure on Azure using Terraform. It demonstrates the complexity that Terraform can manage compared to manual deployment through the Azure Portal.

## What This Demo Deploys
- **Resource Group**: Container for all resources
- **Virtual Network**: Custom network with 10.0.0.0/16 address space
- **Subnet**: 10.0.1.0/24 subnet for VM placement
- **Network Security Group**: Security rules for RDP (3389) and HTTP (80) access
- **Public IP**: Static public IP address
- **Network Interface**: Connects VM to network and public IP
- **Windows Virtual Machine**: Windows Server 2022 with IIS web server

## Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform installed (version 1.0+)
- Azure subscription with Contributor permissions
- No SSH keys required! Uses username/password authentication

## From ClickOps to DevOps

### The ClickOps Way (Manual)
Creating a VM manually involves:
1. Create Resource Group
2. Create Virtual Network
3. Create Subnet
4. Create Network Security Group
5. Configure security rules
6. Create Public IP
7. Create Network Interface
8. Create Virtual Machine
9. Configure VM settings
10. Install and configure software

**Time**: 15-30 minutes, prone to configuration drift and human error.

### The DevOps Way (Terraform)
With Terraform:
1. Define all infrastructure in code
2. Run `terraform apply`
3. Everything is created consistently and documented

**Time**: 2-3 minutes after initial code creation, repeatable and consistent.

## How to Run This Demo

### Local Deployment
```bash
# Navigate to the demo directory
cd demo2-vm-deployment

# Initialize Terraform
terraform init

# Plan the deployment (provide a secure password)
terraform plan -var="admin_password=YourSecurePassword123!"

# Deploy the resources
terraform apply -var="admin_password=YourSecurePassword123!"

# Connect to your VM via RDP
# Use the public IP from the output and the credentials you specified

# Clean up when done
terraform destroy -var="admin_password=YourSecurePassword123!"
```

### GitHub Actions Deployment
Use the GitHub Actions workflow for this demo by:
1. Go to Actions tab in GitHub
2. Select "Demo 2: VM Deployment"
3. Click "Run workflow"
4. Provide a secure admin password
5. Choose "deploy", "plan", or "destroy" action

## After Deployment
1. **Web Access**: Visit the public IP address in your browser to see the demo page
2. **RDP Access**: Connect via RDP using the provided connection information
3. **Explore**: Check out the IIS configuration and server setup

## Learning Points
- **Network Infrastructure**: Understanding VNets, subnets, and security groups
- **VM Configuration**: Automated Windows setup using VM extensions
- **Security**: Password authentication (simpler than SSH keys for demos)
- **Infrastructure Dependencies**: How Terraform manages resource relationships
- **Automation**: Software installation and configuration as part of deployment

## Security Considerations
- Use strong passwords that meet Azure complexity requirements
- Network Security Group rules are restrictive by default
- Consider using Azure Bastion for production RDP access
- The current NSG allows RDP from any IP - restrict this in production

## Cost Considerations
- Standard_B2s VM costs approximately $30-40/month if left running
- Always destroy demo resources when not needed
- Consider using smaller VM sizes for testing

## Next Steps
- Try connecting via RDP and exploring the Windows Server environment
- Modify the PowerShell script to install different software
- Proceed to Demo 3 for a complete application deployment
- Explore Azure VM extensions for additional configuration options