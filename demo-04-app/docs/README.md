# Demo 04: Azure App Service

## Overview
This demo creates a complete web application hosting environment using Azure App Service. It demonstrates modern cloud application deployment with monitoring, staging capabilities, and production-ready configuration.

## What This Demo Creates
- 1 Azure Resource Group
- 1 App Service Plan (Linux)
- 1 Linux Web App (Node.js)
- 1 Application Insights for monitoring
- 1 Staging deployment slot (optional)

## Prerequisites
- Azure CLI installed and configured
- Terraform installed (version >= 1.0)
- Azure subscription with appropriate permissions

## How to Run This Demo

1. Navigate to the terraform directory:
   ```bash
   cd demo-04-app/terraform
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

5. Get the web app URL:
   ```bash
   terraform output app_service_url
   ```

6. Visit your web app in a browser using the output URL

7. Clean up (destroy resources):
   ```bash
   terraform destroy
   ```

## Key Learning Points
- App Service Plan configuration and SKU selection
- Linux Web App deployment with Node.js
- Application Insights integration for monitoring
- Deployment slots for staging environments
- Environment-specific configuration
- App settings and connection strings
- Conditional resource creation

## Production Features
- **Monitoring**: Application Insights for performance monitoring
- **Staging**: Optional deployment slot for testing
- **Configuration**: Environment-specific app settings
- **Scalability**: Configurable App Service Plan SKUs
- **Platform**: Linux containers with Node.js runtime

## Customization
You can customize the deployment by modifying variables:
- `location`: Change the Azure region (default: East US)
- `environment`: Change the environment tag (default: dev)
- `app_service_plan_sku`: Change App Service Plan size (default: B1)
- `node_version`: Change Node.js version (default: 18-lts)
- `create_staging_slot`: Enable staging slot (default: false)

Example with custom variables:
```bash
terraform apply -var="app_service_plan_sku=S1" -var="create_staging_slot=true" -var="node_version=20-lts"
```

## App Service Plan SKUs
- **F1**: Free tier (limited, no custom domains)
- **D1**: Shared tier (limited)
- **B1-B3**: Basic tier (good for development)
- **S1-S3**: Standard tier (production ready)
- **P1v2-P3v2**: Premium tier (high performance)

## Application Settings
The web app includes several pre-configured settings:
- Application Insights connection
- Conference branding (MMSMusic)
- Demo identification
- Node.js version specification

## Deployment Slots
When staging slot is enabled:
- Production URL: `https://your-app.azurewebsites.net`
- Staging URL: `https://your-app-staging.azurewebsites.net`