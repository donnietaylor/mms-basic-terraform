# Copilot Instructions for MMS Basic Terraform Repository

## Repository Overview

This repository contains **Azure Terraform demonstration code** for the MMS Music Conference, showcasing the transition from ClickOps to DevOps. It includes **4 progressive demos** that deploy increasingly complex Azure infrastructure using Infrastructure as Code (IaC) principles.

**Repository Type**: Educational Terraform demos for Azure infrastructure  
**Size**: 26 files, ~911 lines of Terraform code  
**Target Users**: Azure-experienced IT professionals learning Terraform automation  
**Primary Languages**: HCL (Terraform), YAML (GitHub Actions)  
**Cloud Provider**: Microsoft Azure  
**Terraform Version**: 1.5.0  
**Azure Provider**: hashicorp/azurerm ~>3.0  

## Build and Validation Instructions

### Prerequisites
**ALWAYS verify these requirements before making changes:**
- Azure CLI installed and authenticated (`az login`)
- Terraform 1.5.0+ installed locally (if running outside GitHub Actions)
- Azure subscription with Contributor permissions
- For GitHub Actions: Azure service principal configured as repository secrets

### Required Azure Secrets (GitHub Actions)
**These secrets MUST be configured in GitHub repository settings:**
```
AZURE_CREDENTIALS     # Service principal JSON (primary auth method)
ARM_CLIENT_ID         # Service principal client ID  
ARM_CLIENT_SECRET     # Service principal client secret
ARM_SUBSCRIPTION_ID   # Azure subscription ID
ARM_TENANT_ID         # Azure tenant ID
```

### Local Development Workflow
**Use this exact sequence for local testing:**
```bash
# Navigate to any demo directory
cd demo1-basic-resources  # or demo2-vm-deployment, demo3-app-deployment, demo4-state-management

# ALWAYS run these commands in order:
terraform init          # Initialize providers and modules
terraform fmt          # Format code (required by CI)
terraform validate     # Validate syntax and configuration
terraform plan         # Preview changes (safe, no modifications)
terraform apply        # Deploy resources (requires confirmation)
terraform destroy      # Clean up resources (IMPORTANT: avoid costs)
```

**Build Time Expectations:**
- **Demo 1**: ~2 minutes (basic resources)
- **Demo 2**: ~5 minutes (VM deployment) 
- **Demo 3**: ~8 minutes (full application stack)
- **Demo 4**: ~4 minutes (state management setup)

### GitHub Actions Deployment
**All demos support automated deployment via workflows:**

1. Navigate to **Actions** tab in GitHub
2. Select desired demo workflow:
   - "Demo 1: Basic Resources"
   - "Demo 2: VM Deployment" 
   - "Demo 3: Full App Deployment"
   - "Demo 4: State Management"
3. Click **"Run workflow"**
4. Choose action: `plan` (preview), `deploy` (create), or `destroy` (cleanup)
5. Provide required inputs (passwords, resource names)

**Critical Validation Steps:**
- **terraform fmt -check**: Code formatting validation (will fail CI if not formatted)
- **terraform validate**: Syntax and configuration validation
- **terraform plan**: Change preview and validation
- All workflows include these checks automatically

### Common Issues and Solutions
**Issue**: `terraform: command not found`  
**Solution**: Install Terraform 1.5.0+ or use GitHub Actions workflows

**Issue**: Azure authentication failures  
**Solution**: Run `az login` for local development, verify GitHub secrets for Actions

**Issue**: Resource naming conflicts  
**Solution**: Use unique names (storage accounts must be globally unique)

**Issue**: Permission denied errors  
**Solution**: Ensure Azure service principal has Contributor role on subscription

## Project Layout and Architecture

### Directory Structure
```
/
├── .github/workflows/           # GitHub Actions CI/CD pipelines
│   ├── demo1-basic-resources.yml    # Basic resources deployment
│   ├── demo2-vm-deployment.yml      # VM infrastructure deployment  
│   ├── demo3-app-deployment.yml     # Full application deployment
│   └── demo4-state-management.yml   # State management demonstration
├── demo1-basic-resources/       # 🟢 Basic: Resource Group + Storage
│   ├── main.tf                     # Core infrastructure definition
│   ├── variables.tf                # Input parameters  
│   ├── outputs.tf                  # Output values
│   ├── terraform.tfvars.example    # Example variable values
│   └── README.md                   # Demo-specific documentation
├── demo2-vm-deployment/         # 🟡 Intermediate: Windows VM + Networking
│   ├── main.tf                     # VM infrastructure (149 lines)
│   ├── variables.tf                # VM configuration parameters
│   ├── outputs.tf                  # RDP connection information
│   └── README.md                   # VM deployment guide
├── demo3-app-deployment/        # 🔴 Advanced: App Service + Database + Monitoring
│   ├── main.tf                     # Full application stack (221 lines)
│   ├── variables.tf                # Application configuration
│   ├── outputs.tf                  # Application URLs and connection info
│   └── README.md                   # Enterprise deployment guide
├── demo4-state-management/      # 🟡 Intermediate: Remote State + Drift Detection
│   ├── main.tf                     # State backend + drift demo resources (193 lines)
│   ├── variables.tf                # State configuration parameters
│   ├── outputs.tf                  # State backend information
│   └── README.md                   # State management concepts
├── README.md                     # Main repository documentation (7,865 bytes)
└── .gitignore                    # Terraform-specific ignore patterns
```

### Key Architecture Patterns

**Demo 1: Foundation Pattern** (Basic Resources)
- Resource Group → Storage Account → Blob Container
- **Purpose**: Terraform basics and IaC introduction
- **Resources**: 3 basic Azure resources
- **Use Case**: Learning fundamental Terraform syntax

**Demo 2: Compute Pattern** (VM Infrastructure)  
- Resource Group → VNet → Subnet → NSG → Public IP → NIC → Windows VM
- **Purpose**: Complex infrastructure relationships
- **Resources**: Complete Windows Server 2022 environment with RDP access
- **Use Case**: Understanding networking and security

**Demo 3: Application Pattern** (Enterprise PaaS)
- Resource Group → App Service Plan → App Service → SQL Database → Key Vault → Application Insights
- **Purpose**: Production-ready application deployment
- **Resources**: Full PaaS application with monitoring and secrets management
- **Use Case**: Enterprise application architecture

**Demo 4: State Management Pattern** (Backend + Drift)
- Remote State Storage → Windows VM + IIS → NSG (drift target) → Application Insights
- **Purpose**: State management and configuration drift detection
- **Resources**: State backend infrastructure + demo resources for drift testing
- **Use Case**: Advanced Terraform state concepts

### Configuration Files

**Terraform Configuration**:
- **Provider**: azurerm ~>3.0 (Azure Resource Manager)
- **Additional Providers**: random ~>3.1 (Demo 3 only)
- **Backend**: Local state (Demos 1-3), Remote state (Demo 4)
- **Variable Files**: terraform.tfvars.example in each demo

**GitHub Actions Configuration**:
- **Runner**: ubuntu-latest
- **Terraform Version**: 1.5.0 (pinned)
- **Authentication**: Azure service principal via secrets
- **Validation**: fmt check, validate, plan before apply

### Critical Dependencies

**Azure Resources** (created in dependency order):
1. **Resource Group**: Container for all resources (always first)
2. **Networking**: VNet → Subnet → NSG → Public IP (for VM demos)
3. **Compute**: VM → NIC → Disk (dependent on networking)
4. **PaaS Services**: App Service Plan → App Service → Database (parallel deployment)
5. **Security**: Key Vault → Access Policies (dependent on App Service identity)
6. **Monitoring**: Application Insights → Log Analytics Workspace

**Terraform Dependencies**:
- All demos depend on `azurerm_resource_group` being created first
- VMs require complete networking stack before creation
- App Services require App Service Plan before creation
- Key Vault access policies require App Service managed identity

## Key Facts for Code Changes

### Where to Make Common Changes

**Adding Azure Resources**: Modify `main.tf` in relevant demo directory  
**Changing Resource Configuration**: Update variables in `variables.tf`  
**Modifying Outputs**: Edit `outputs.tf` to expose new resource properties  
**Updating Documentation**: Modify demo-specific `README.md` files
**Changing CI/CD**: Update `.github/workflows/` YAML files

### Terraform Best Practices (CRITICAL)

1. **ALWAYS run `terraform fmt`** before committing (CI will fail otherwise)
2. **Use consistent naming**: `azurerm_resource_group.demo{N}` pattern
3. **Include comprehensive tags**: Environment, Conference, Demo tags on all resources
4. **Handle sensitive variables**: Use `sensitive = true` in variable definitions
5. **Use data sources**: Reference existing resources with `data` blocks (Demo 4)
6. **Remote state**: Demo 4 uses remote Azure Storage backend exclusively

### Variable Patterns

**Required Variables** (all demos):
- `resource_group_name`: Azure resource group name
- `location`: Azure region (default: "East US")

**Demo-Specific Variables**:
- **Demo 1**: `storage_account_name` (globally unique)
- **Demo 2**: `admin_password` (VM administrator password)
- **Demo 3**: `db_admin_password` (database password), `app_service_sku` (F1/S1)
- **Demo 4**: `admin_password` (VM password for drift demo)

### Security Considerations

**Secrets Management**:
- Never commit `.tfvars` files (excluded by .gitignore)
- Use Azure Key Vault for application secrets (Demo 3)
- Sensitive variables marked with `sensitive = true`
- Database passwords required for deployment

**State Security**:
- Demo 4 demonstrates sensitive data in state files
- Remote state uses Azure Storage with encryption at rest
- State files contain VM passwords and connection strings

## Validation and Testing

### Pre-Deployment Validation
**Always run these commands before applying changes:**
```bash
terraform fmt -recursive    # Format all .tf files
terraform init             # Initialize/update providers
terraform validate         # Check syntax and references
terraform plan            # Preview all changes
```

### Post-Deployment Validation
**Verify deployments using these checks:**
```bash
terraform output          # Display output values
terraform show           # Show current state
az resource list --resource-group <rg-name>  # Verify Azure resources
```

### Demo-Specific Testing

**Demo 1**: Verify storage account and container creation in Azure Portal  
**Demo 2**: Test RDP connection to Windows VM using output IP address  
**Demo 3**: Access application URL and verify database connectivity  
**Demo 4**: Manually modify NSG rules in Portal, then run `terraform plan` to detect drift

### GitHub Actions Validation
All workflows automatically run:
1. Terraform format check (`terraform fmt -check`)
2. Terraform validation (`terraform validate`)  
3. Plan generation (`terraform plan`)
4. Conditional apply/destroy based on user input

## Trust These Instructions

**Agent Instructions**: Trust this documentation and only search the codebase if:
- Information is incomplete or contradictory
- You need specific implementation details not covered here
- You encounter errors not documented in the troubleshooting sections

**Common Search Patterns to Avoid**:
- Searching for build scripts (none exist - use Terraform directly)
- Looking for package.json or requirements files (pure Terraform project)
- Searching for test files (demos are self-validating)

**When to Search**:
- Finding specific resource configurations in `main.tf` files
- Locating exact variable names in `variables.tf`
- Understanding resource relationships in complex demos (3-4)
- Checking output formats in `outputs.tf`

This repository follows consistent patterns across all demos, making it predictable for automated agents to work with efficiently.