# MMS Music Conference - Azure Terraform Demos

🎵 **From ClickOps to DevOps: Terraform for Azure** 🎵

This repository contains three progressive demos showcasing how to transition from manual Azure resource management (ClickOps) to Infrastructure as Code (DevOps) using Terraform. Designed for Azure-experienced IT professionals ready to embrace automation.

## 🎯 Demo Overview

| Demo | Complexity | Resources | Purpose | Runtime |
|------|------------|-----------|---------|---------|
| **[Demo 1](./demo1-basic-resources/)** | 🟢 Basic | Resource Group, Storage Account | Introduction to IaC | ~2 mins |
| **[Demo 2](./demo2-vm-deployment/)** | 🟡 Intermediate | VM, VNet, NSG, Public IP | Infrastructure deployment | ~5 mins |
| **[Demo 3](./demo3-app-deployment/)** | 🔴 Advanced | App Service, Database, Key Vault, Monitoring | Enterprise application | ~8 mins |
| **[Demo 4](./demo4-state-management/)** | 🟡 Intermediate | State Storage, NSG, VNet, App Insights | State management & drift | ~4 mins |

## 🚀 Quick Start

### Prerequisites
- Azure subscription with Contributor permissions
- Azure CLI installed and authenticated (`az login`)
- For GitHub Actions: Azure service principal configured as repository secrets

### Running Demos Locally
```bash
# Clone the repository
git clone https://github.com/donnietaylor/mms-basic-terraform.git
cd mms-basic-terraform

# Choose your demo
cd demo1-basic-resources  # or demo2-vm-deployment or demo3-app-deployment

# Initialize and deploy
terraform init
terraform plan
terraform apply

# Clean up when done
terraform destroy
```

### Running via GitHub Actions
1. Navigate to the **Actions** tab in GitHub
2. Select your desired demo workflow
3. Click **"Run workflow"**
4. Provide required inputs (SSH keys, passwords, etc.)
5. Choose **deploy**, **plan**, or **destroy**

## 📚 Learning Path

### Demo 1: Basic Resources
**Perfect for**: First-time Terraform users
- **What you'll learn**: Basic Terraform syntax, Azure provider, resource dependencies
- **What you'll deploy**: Resource Group, Storage Account, Blob Container
- **Key concepts**: Infrastructure as Code, state management, reproducibility

### Demo 2: VM Deployment  
**Perfect for**: Understanding complex infrastructure
- **What you'll learn**: Networking, security groups, virtual machines, cloud-init
- **What you'll deploy**: Complete VM infrastructure with web server
- **Key concepts**: Resource relationships, security, automation

### Demo 3: Full Application
**Perfect for**: Enterprise-ready deployments
- **What you'll learn**: PaaS services, secrets management, monitoring, staging
- **What you'll deploy**: Production-ready web application with database
- **Key concepts**: Security best practices, DevOps workflows, scalability

### Demo 4: State Management
**Perfect for**: Understanding Terraform's core concepts
- **What you'll learn**: State storage, drift detection, remote backends, state security
- **What you'll deploy**: State infrastructure with drift demonstration resources
- **Key concepts**: Remote state, configuration drift, state locking, sensitive data handling

## 🔧 Required Azure Secrets (for GitHub Actions)

To use the GitHub Actions workflows, configure these repository secrets:

```
AZURE_CREDENTIALS     # Service principal JSON
ARM_CLIENT_ID         # Service principal client ID  
ARM_CLIENT_SECRET     # Service principal client secret
ARM_SUBSCRIPTION_ID   # Azure subscription ID
ARM_TENANT_ID         # Azure tenant ID
```

### Creating Azure Service Principal
```bash
# Create service principal
az ad sp create-for-rbac --name "terraform-demos" --role contributor \
  --scopes /subscriptions/{subscription-id} --sdk-auth

# Output will be JSON - add as AZURE_CREDENTIALS secret
# Individual values can be extracted for ARM_* secrets
```

## 🎵 From ClickOps to DevOps Journey

### The ClickOps Challenge
- ⏰ **Time-consuming**: 15-90 minutes per deployment
- 🔄 **Inconsistent**: Manual steps lead to configuration drift  
- 📝 **Undocumented**: No clear record of what was deployed
- 👥 **Non-collaborative**: Hard to review and share changes
- 🐛 **Error-prone**: Human mistakes in complex deployments

### The DevOps Solution
- ⚡ **Fast**: 2-8 minutes per deployment
- 🎯 **Consistent**: Same code = identical infrastructure every time
- 📚 **Self-documenting**: Code IS the documentation
- 🤝 **Collaborative**: Version control, pull requests, code reviews
- ✅ **Reliable**: Automated validation and testing

## 🏗️ Architecture Patterns Demonstrated

### Demo 1: Foundation Pattern
```
Resource Group
└── Storage Account
    └── Blob Container
```

### Demo 2: Compute Pattern  
```
Resource Group
├── Virtual Network
│   └── Subnet
├── Network Security Group
├── Public IP
├── Network Interface
└── Virtual Machine (Ubuntu + Nginx)
```

### Demo 3: Application Pattern
```
Resource Group
├── App Service Plan
├── App Service (Production)
│   └── Staging Slot
├── PostgreSQL Flexible Server
│   └── Database
├── Key Vault
│   └── Database Connection String
└── Application Insights
```

### Demo 4: State Management Pattern
```
Resource Group (State Storage)
├── Storage Account (Remote State Backend)
│   └── Blob Container (tfstate files)
├── Network Security Group (Drift Demo)
├── Virtual Network (Supporting Infrastructure)
└── Application Insights (Sensitive Data Demo)
```

## 💡 Key Learning Outcomes

After completing these demos, you'll understand:

- ✅ **Infrastructure as Code fundamentals**
- ✅ **Terraform syntax and best practices**  
- ✅ **Azure resource relationships and dependencies**
- ✅ **State management and remote backends**
- ✅ **Configuration drift detection and remediation**
- ✅ **Security best practices (Managed Identity, Key Vault)**
- ✅ **Monitoring and observability setup**
- ✅ **DevOps workflow integration**
- ✅ **Cost optimization strategies**

## 🎤 Conference Presentation Notes

These demos support a **60-75 minute presentation** with the following flow:

1. **Introduction** (5 mins): ClickOps vs DevOps overview
2. **Demo 1** (10 mins): Basic concepts and first deployment
3. **Demo 2** (15 mins): Complex infrastructure and networking
4. **Demo 3** (20 mins): Enterprise application with monitoring
5. **Demo 4** (10 mins): State management and drift detection
6. **Q&A** (10-15 mins): Audience questions and discussion

### Presenter Tips
- Emphasize **time savings** and **consistency** benefits
- Show both **code** and **Azure Portal** results
- Highlight **security improvements** with IaC
- Discuss **cost implications** of each demo
- Share **real-world production** experiences

## 🛡️ Security & Best Practices

- 🔐 **Secrets Management**: Sensitive data stored in Key Vault
- 🆔 **Managed Identity**: No hardcoded credentials
- 🌐 **Network Security**: Proper firewall and NSG rules
- 📊 **Monitoring**: Application Insights for observability
- 🔄 **State Management**: Terraform state best practices
- 💰 **Cost Control**: Appropriate SKUs for demo vs production

## 📞 Support & Resources

- **Issues**: Report problems via GitHub Issues
- **Documentation**: Each demo includes detailed README
- **Terraform Docs**: [terraform.io](https://terraform.io)
- **Azure Provider**: [registry.terraform.io/providers/hashicorp/azurerm](https://registry.terraform.io/providers/hashicorp/azurerm)

---
**🎵 Ready to rock your infrastructure? Let's go from ClickOps to DevOps! 🎵**
