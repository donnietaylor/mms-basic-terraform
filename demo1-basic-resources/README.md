# Demo 1: Basic Azure Resources

## Overview
This demo introduces the basics of Infrastructure as Code using Terraform for Azure. It demonstrates how to transition from manual resource creation (ClickOps) to automated deployment using Terraform.

## What This Demo Deploys
- **Resource Group**: A logical container for Azure resources
- **Storage Account**: A general-purpose storage account with Standard LRS replication
- **Storage Container**: A blob container for file storage

## Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform installed (version 1.0+)
- Azure subscription with Contributor permissions

## From ClickOps to DevOps

### The ClickOps Way (Manual)
Traditionally, you might create these resources through:
1. Azure Portal → Create Resource Group
2. Azure Portal → Create Storage Account
3. Configure settings manually
4. No version control or repeatability

### The DevOps Way (Terraform)
With Terraform, you:
1. Define infrastructure as code
2. Version control your infrastructure
3. Ensure consistency across environments
4. Enable automation and repeatability

## How to Run This Demo

### Local Deployment
```bash
# Navigate to the demo directory
cd demo1-basic-resources

# Initialize Terraform
terraform init

# Preview the changes
terraform plan

# Deploy the resources
terraform apply

# Clean up when done
terraform destroy
```

### GitHub Actions Deployment
Use the GitHub Actions workflow for this demo by:
1. Go to Actions tab in GitHub
2. Select "Demo 1: Basic Resources"
3. Click "Run workflow"
4. Choose "deploy" or "destroy" action

## Learning Points
- **Infrastructure as Code**: All resources defined in version-controlled files
- **Repeatability**: Same configuration creates identical resources every time
- **Documentation**: Code serves as documentation of your infrastructure
- **Collaboration**: Team members can review and modify infrastructure through pull requests

## Next Steps
- Proceed to Demo 2 to see VM deployment
- Try modifying variables to customize the deployment
- Explore Terraform state management concepts