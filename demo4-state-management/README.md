# Demo 4: Terraform State Management and Configuration Drift Detection

This demo demonstrates how Terraform state management works and how it detects configuration drift when resources are manually modified outside of Terraform.

## 🎯 Demo Objectives

- Show how Terraform uses state to track resource configuration
- Demonstrate configuration drift detection when resources are manually changed
- Illustrate the importance of remote state storage for team collaboration
- Highlight sensitive data in state files and security implications

## 🏗️ Infrastructure Overview

This demo creates:

- **Resource Group**: `rg-mms-demo4-state` (matches GitHub Actions configuration)
- **Network Security Group**: Main target for drift demonstration
  - RDP rule (source: `10.0.0.0/8`) - Change to `*` for drift demo
  - HTTP rule (port 80) - Delete entirely for drift demo
- **Windows Virtual Machine**: For additional drift scenarios
- **Virtual Network & Subnet**: Standard networking setup
- **Application Insights**: Demonstrates sensitive data in state

## 🚀 Quick Start

**This demo is deployed EXCLUSIVELY via GitHub Actions workflow** - no local deployment needed!

1. **Go to GitHub Actions** in your repository
2. **Run the workflow**: `.github/workflows/demo4-state-management.yml`
3. **Choose action**: 
   - `plan` - See what will be created
   - `deploy` - Create the infrastructure  
   - `destroy` - Clean up resources
4. **Configure inputs**:
   - Resource Group: `rg-mms-demo4-state` (default)
   - Admin Password: Minimum 12 characters with complexity requirements

**The workflow handles everything:**
- ✅ Remote state backend creation (if first run)
- ✅ Storage account and container for state files  
- ✅ State migration from local to remote (bootstrap)
- ✅ All subsequent runs use remote state automatically

## 🔍 Configuration Drift Demonstration

### Step 1: Deploy Initial Configuration
Run the GitHub Actions workflow with action `deploy` to create all resources.

### Step 2: Create Configuration Drift
Go to the Azure Portal and manually modify the Network Security Group:

1. **Find the NSG**: Look for `nsg-demo4-drift-XXXXXXXX` in resource group `rg-mms-demo4-state`
2. **Modify RDP Rule**: 
   - Edit the RDP rule (priority 1001)
   - Change source from `10.0.0.0/8` to `*` (Any source)
   - Save changes
3. **Delete HTTP Rule**:
   - Delete the HTTP rule (priority 1002) entirely
   - Confirm deletion

### Step 3: Detect Drift
Run the GitHub Actions workflow with action `plan`

Terraform will detect:
- ✅ RDP rule source has changed from `10.0.0.0/8` to `*`
- ✅ HTTP rule has been deleted and needs to be recreated

### Step 4: Correct Drift
Run the GitHub Actions workflow with action `deploy`

Terraform will:
- Revert RDP rule source back to `10.0.0.0/8`
- Recreate the missing HTTP rule

## 🔐 State Security Demonstration

### Sensitive Data in State
The state file contains sensitive information:
- VM administrator password
- Application Insights instrumentation key
- Resource connection strings and keys

### View Sensitive Data (DO NOT DO IN PRODUCTION)
```bash
# Show that state contains sensitive data
terraform show | grep -i password
terraform show | grep -i instrumentation_key
```

**This demonstrates why:**
- State files should NEVER be committed to version control
- Remote state with encryption at rest is essential
- State file access should be restricted to authorized personnel only

## 🎪 Conference Presentation Flow

1. **Show Clean Infrastructure**: `terraform apply` from GitHub Actions
2. **Demonstrate Portal Changes**: Modify NSG rules manually
3. **Detect Drift**: `terraform plan` shows differences
4. **Fix Drift**: `terraform apply` corrects configuration
5. **Security Highlight**: Show sensitive data in state (carefully!)

## 📝 Key Learning Points

- **State is Truth**: Terraform state is the source of truth for infrastructure
- **Drift Detection**: Manual changes are detected on next `terraform plan`
- **Drift Correction**: `terraform apply` brings resources back to desired state
- **Remote State**: Essential for team collaboration and CI/CD
- **State Security**: Contains sensitive data, must be properly secured

## 🔗 Related Resources

- [Terraform State Documentation](https://www.terraform.io/docs/language/state/index.html)
- [Remote State Backends](https://www.terraform.io/docs/language/settings/backends/index.html)
- [State Security Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html)

## ⚠️ Important Notes

- **NO LOCAL STATE**: This demo uses remote state exclusively
- **Security First**: Never commit state files or sensitive variables
- **Clean Up**: Remember to destroy resources after demo to avoid costs
- **Resource Group**: Uses `rg-mms-demo4-state` as specified for consistency

## 🧹 Cleanup

Destroy all resources after the demonstration:
- Run GitHub Actions workflow with action `destroy`

Or delete the entire resource group `rg-mms-demo4-state` from Azure Portal for faster cleanup.
