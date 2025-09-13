# MMS-Basic-Terraform

Repository to demo basic Azure deployments with Terraform for MMSMusic conference. This repository contains 4 progressively complex demos designed for IT professionals with mixed Azure experience.

## 🎯 Demo Overview

### Demo 01: Basic Resource Group
**Complexity**: Extremely Basic  
**Purpose**: Introduction to Terraform basics  
**Creates**: 1 Resource Group  
**Key Concepts**: Basic Terraform structure, Azure provider, variables, outputs

### Demo 02: Storage Account
**Complexity**: Basic  
**Purpose**: Resource dependencies and Azure Storage  
**Creates**: Resource Group + Storage Account + Container  
**Key Concepts**: Resource dependencies, random provider, storage configuration

### Demo 03: Virtual Machine
**Complexity**: Intermediate  
**Purpose**: Complex networking and VM deployment  
**Creates**: Resource Group + VNet + VM + Security Groups + Public IP  
**Key Concepts**: Virtual networking, security, SSH keys, complex dependencies

### Demo 04: App Service
**Complexity**: Advanced  
**Purpose**: Modern web application deployment  
**Creates**: Resource Group + App Service Plan + Web App + Application Insights + Optional Staging Slot  
**Key Concepts**: PaaS services, monitoring, deployment slots, production configuration

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and configured
- Terraform >= 1.0 installed
- Azure subscription with appropriate permissions
- For GitHub Actions: Azure service principal configured

### Running Demos Locally

1. Choose a demo directory:
   ```bash
   cd demo-0X-name/terraform
   ```

2. Initialize and run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Clean up:
   ```bash
   terraform destroy
   ```

### Running via GitHub Actions

Each demo has a dedicated GitHub Actions workflow with dispatch triggers:

1. Go to Actions tab in GitHub
2. Select the desired demo workflow
3. Click "Run workflow"
4. Configure parameters and run

Available workflows:
- **Demo 01 - Basic Resource Group**
- **Demo 02 - Storage Account** 
- **Demo 03 - Virtual Machine**
- **Demo 04 - App Service**

## 📁 Repository Structure

```
mms-basic-terraform/
├── demo-01-basic/
│   ├── terraform/          # Terraform configuration files
│   └── docs/              # Demo-specific documentation
├── demo-02-storage/
│   ├── terraform/
│   └── docs/
├── demo-03-vm/
│   ├── terraform/
│   └── docs/
├── demo-04-app/
│   ├── terraform/
│   └── docs/
├── .github/workflows/     # GitHub Actions workflows
└── README.md
```

## 🔧 Configuration Options

Each demo supports various configuration options through variables:

- **Environment**: dev, staging, prod
- **Location**: Multiple Azure regions supported
- **Demo-specific options**: VM sizes, storage tiers, app service SKUs, etc.

## 🎓 Learning Path

**Recommended order for maximum learning impact:**

1. **Start with Demo 01** - Learn Terraform basics
2. **Progress to Demo 02** - Understand dependencies and additional providers
3. **Advance to Demo 03** - Master complex networking and VMs
4. **Complete with Demo 04** - Explore modern PaaS and production features

## 🏷️ Resource Naming Convention

All resources follow a consistent naming pattern:
- Resource Groups: `rg-mms-demo-XX-{environment}`
- Other resources: `{type}-mms-demo-XX-{suffix}`
- Tags include: Environment, Demo, Conference (MMSMusic), Purpose

## 🔐 Security Considerations

- All demos include appropriate security configurations
- VM demo includes Network Security Groups with limited access
- Sensitive outputs are marked as sensitive
- Each demo creates isolated resource groups

## 🤝 Contributing

This repository is designed for conference demonstrations. Each demo is self-contained and can be run independently.

## 📝 License

MIT License - feel free to use these demos for your own learning and presentations.

---

**MMSMusic Conference - Terraform Infrastructure Demos**  
*Demonstrating Infrastructure as Code best practices with Azure*
