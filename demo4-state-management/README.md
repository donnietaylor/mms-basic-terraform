# Demo 4: Terraform State Management & Drift Detection

## Overview
This demo focuses on one of Terraform's most critical concepts: **state management** and **configuration drift detection**. You'll learn how Terraform tracks infrastructure changes, detects when resources have been modified outside of Terraform, and how it reconciles these differences.

**🎯 This demo now uses remote state by default**, making it production-ready and suitable for GitHub Workflows and team collaboration.

**✨ New: Automatic Import Functionality** - This demo now includes import blocks to automatically handle existing resources, preventing state conflicts when resources already exist in Azure.

## What This Demo Deploys
- **Resource Group**: Container for all demo resources and state storage  
- **Storage Account**: Demonstrates remote state backend best practices
- **Storage Container**: Houses Terraform state files securely
- **Network Security Group**: The "target" resource for drift demonstration
- **Virtual Network**: Supporting infrastructure  
- **Application Insights**: Shows how sensitive data is handled in state

## Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform installed (version 1.0+)
- Azure subscription with Contributor permissions
- Basic understanding of previous demos (1-3)

## Understanding Terraform State

### What is Terraform State?
Terraform state is a **mapping between your configuration files and real-world resources**. It:
- 🗺️ **Maps** configuration to actual Azure resource IDs
- 📊 **Tracks** metadata about resources and dependencies  
- 🔒 **Enables** locking to prevent concurrent modifications
- 📈 **Improves** performance by caching resource attributes
- 🔍 **Detects** drift between configuration and actual state

### Local vs Remote State

#### Local State (Development/Testing Only)
```bash
# State stored in terraform.tfstate file locally
terraform apply
ls -la terraform.tfstate  # Contains sensitive data!
```

**Limitations:**
- ❌ Cannot share state across team members
- ❌ No locking mechanism (concurrent modifications)
- ❌ Sensitive data stored locally in plain text
- ❌ No versioning or backup capabilities

#### Remote State (Production Best Practice - **Used by Default in This Demo**)
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mms-demo4-state"
    storage_account_name = "statemmsdemo4state"
    container_name       = "tfstate"
    key                  = "demo4.terraform.tfstate"
  }
}
```

**Benefits:**
- ✅ **Shared** state across team members
- ✅ **Automatic** state locking during operations
- ✅ **Encrypted** storage with Azure security
- ✅ **Versioned** state with blob versioning
- ✅ **Backup** and recovery capabilities
- ✅ **Import blocks** handle existing resources automatically

## Resource Import Functionality

This demo includes **import blocks** that automatically handle existing Azure resources. If you encounter errors like "resource already exists", the import blocks will bring those resources under Terraform management without recreating them.

### Import Blocks Included:
```hcl
# Imports existing resource group
import {
  to = azurerm_resource_group.demo4
  id = "/subscriptions/19381250-e2a4-43b0-b620-663c2a3da3c4/resourceGroups/rg-mms-demo4-state"
}

# Imports existing storage account
import {
  to = azurerm_storage_account.state_storage
  id = "/subscriptions/19381250-e2a4-43b0-b620-663c2a3da3c4/resourceGroups/rg-mms-demo4-state/providers/Microsoft.Storage/storageAccounts/statemmsdemo4state"
}

# Imports existing storage container
import {
  to = azurerm_storage_container.state_container
  id = "https://statemmsdemo4state.blob.core.windows.net/tfstate"
}
```

**⚠️ Important:** If you're using a different Azure subscription, update the subscription ID in the import blocks above to match your environment.

**Benefits of Import Blocks:**
- ✅ **Resolves** "resource already exists" errors
- ✅ **Preserves** existing resource configuration
- ✅ **Brings** resources under Terraform management
- ✅ **Prevents** accidental resource recreation
- ✅ **Enables** team collaboration on existing infrastructure

## How to Run This Demo

### Running via GitHub Workflows (Recommended)
1. Navigate to **Actions** tab in the GitHub repository
2. Select **Demo 4: State Management** workflow
3. Click **Run workflow**
4. Choose action: `plan`, `deploy`, or `destroy`
5. Optionally specify a custom resource group name
6. Click **Run workflow**

**🎯 The workflow automatically handles remote state setup and migration!**

### Running Locally (Advanced)

#### Phase 1: Deploy Infrastructure
```bash
# Navigate to the demo directory
cd demo4-state-management

# Initialize Terraform (will use remote backend if storage exists)
terraform init

# Preview the changes
terraform plan

# Deploy the resources
terraform apply

# Review the outputs
terraform output
```

**Note:** Local runs will also use remote state after the first deployment.

### Phase 2: Examine Local State
```bash
# Look at the state file (NEVER edit manually!)
terraform show

# List all tracked resources
terraform state list

# Get details about a specific resource
terraform state show azurerm_network_security_group.demo4

# See sensitive outputs (requires confirmation)
terraform output application_insights_instrumentation_key
```

### Phase 3: Demonstrate Configuration Drift

**Step 1: Make Manual Changes in Azure Portal**
1. Navigate to Azure Portal → Resource Groups → `rg-mms-demo4-state`
2. Open the Network Security Group: `nsg-demo4-drift`
3. Go to **Inbound security rules**
4. **Delete** the HTTP rule (port 80)
5. **Modify** the SSH rule to allow from `0.0.0.0/0` instead of `10.0.0.0/8`
6. **Add** a new rule: HTTPS (port 443) from anywhere

**Step 2: Detect Drift with GitHub Workflows**
```bash
# In the GitHub repository:
# 1. Go to Actions → Demo 4: State Management
# 2. Run workflow with action = "plan"
# 3. Review the workflow output to see drift detection

# You'll see output like:
# ~ azurerm_network_security_group.demo4 will be updated in-place
# + security_rule {
#     + name = "HTTP" (new rule to be restored)
# - security_rule {
#     - name = "HTTPS" (manual rule to be removed)
# ~ security_rule {
#     ~ source_address_prefix = "0.0.0.0/0" -> "10.0.0.0/8" (drift fix)
```

**Step 3: Fix Drift with GitHub Workflows** 
```bash
# In the GitHub repository:
# 1. Go to Actions → Demo 4: State Management  
# 2. Run workflow with action = "deploy"
# 3. Verify in Azure Portal that changes are reverted
```

### Phase 4: Understanding Remote State (No Migration Needed!)
```bash
# This demo now uses remote state by default!
# Check the backend configuration:
terraform output remote_state_setup_instructions

# State is automatically stored in Azure Storage Account
# and accessible to your team and CI/CD pipelines
```

## Key Learning Points

### State Management Best Practices
- ✅ **Always use remote state** for production workloads
- ✅ **Enable state locking** to prevent corruption
- ✅ **Version your state** with blob versioning
- ✅ **Backup state regularly** with Azure Storage redundancy
- ✅ **Secure state access** with proper IAM policies
- ❌ **Never edit state files manually**
- ❌ **Never commit state files to version control**

### Configuration Drift Detection
- 🔍 **`terraform plan`** always compares desired vs actual state
- 🛠️ **`terraform apply`** fixes drift by updating resources
- 📊 **`terraform refresh`** updates state without making changes
- 🚨 **Drift is inevitable** in production environments
- 🔄 **Regular planning** helps catch drift early

### Sensitive Data in State
- 🔐 State files contain **sensitive values** (passwords, keys, connection strings)
- 🏦 Remote backends provide **encryption at rest**
- 👥 **Access control** is critical for state security
- 🚫 **Never store state in public repositories**

## Troubleshooting

### Resource Already Exists Errors
If you encounter "resource already exists" errors, the import blocks should handle this automatically. However, if you need to add additional import blocks:

```bash
# Find the resource ID in Azure
az resource show --name <resource-name> --resource-group <rg-name> --resource-type <resource-type>

# Add import block to main.tf
import {
  to = <terraform_resource_name>
  id = "<azure_resource_id>"
}
```

### State Lock Issues
```bash
# If state is locked and operation failed
terraform force-unlock <LOCK_ID>

# Only use if you're certain no one else is running operations
```

### State Corruption
```bash
# Create a backup before any state operations
terraform state pull > backup.tfstate

# If state is corrupted, restore from backup
terraform state push backup.tfstate
```

### Remote State Access Issues
```bash
# Verify Azure authentication
az account show

# Check storage account permissions
az storage account show -n <storage-account-name> -g <resource-group-name>
```

## Production Considerations

### State Security
- Use **Azure Key Vault** for additional encryption
- Implement **network access restrictions** on storage account
- Enable **Azure AD authentication** for storage access
- Configure **private endpoints** for storage account access

### State Management
- Set up **automated state backups**
- Implement **state file retention policies** 
- Use **separate state files** for different environments
- Configure **state locking timeouts** appropriately

### Team Collaboration
- Use **consistent Terraform versions** across team
- Implement **CI/CD pipelines** for state operations
- Set up **automated drift detection** in pipelines
- Document **state migration procedures**

## Cost Considerations
- Storage Account: ~$1-2/month for state storage
- Application Insights: Free tier available
- Network resources: No additional charges
- **Always destroy demo resources** when finished: `terraform destroy`

## Next Steps
- Explore **Terraform Cloud** for enhanced state management
- Learn about **state file encryption** with customer-managed keys
- Implement **automated drift detection** in CI/CD pipelines
- Study **state file splitting strategies** for large infrastructures
- Practice **disaster recovery** scenarios with state backups

## Real-World Applications
This demo simulates common production scenarios:
- 👨‍💼 **Operations team** manually modifies firewall rules for troubleshooting
- 🔧 **Platform team** runs Terraform to restore compliance
- 🚨 **Security team** detects unauthorized changes through drift detection
- 📊 **DevOps team** uses state management for change tracking

## Security Features Demonstrated
- ✅ Remote state encryption at rest
- ✅ State locking mechanisms
- ✅ Sensitive data handling in outputs
- ✅ Access control for state storage
- ✅ Drift detection for security compliance