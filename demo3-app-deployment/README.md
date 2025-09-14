# Demo 3: Full Application Deployment

## Overview
This is the most comprehensive demo, showcasing a complete production-ready application deployment on Azure. It demonstrates enterprise-grade features including secrets management, monitoring, staging environments, and database integration.

## What This Demo Deploys
- **Resource Group**: Container for all application resources
- **App Service Plan**: Hosting plan for the web application (configurable SKU)
- **App Service**: Windows-based web app with .NET runtime
- **Staging Slot**: Separate staging environment for testing
- **Azure SQL Database**: Managed database service
- **SQL Database**: Application database
- **Key Vault**: Secure storage for connection strings and secrets
- **Application Insights**: Application performance monitoring and logging
- **Managed Identity**: Secure authentication between services

## Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform installed (version 1.0+)
- Azure subscription with Contributor permissions
- Database admin password (minimum 8 characters)

## From ClickOps to DevOps

### The ClickOps Way (Manual)
Creating a production application manually requires:
1. Create Resource Group
2. Create App Service Plan
3. Create App Service
4. Configure runtime settings
5. Create SQL server
6. Configure firewall rules
7. Create database
8. Create Key Vault
9. Configure access policies
10. Store connection strings
11. Create Application Insights
12. Link monitoring to app
13. Create staging slot
14. Configure deployment settings
15. Set up managed identity
16. Configure all service connections

**Time**: 45-90 minutes, complex configuration, high chance of errors.

### The DevOps Way (Terraform)
With Terraform:
1. Define complete application stack in code
2. Run `terraform apply`
3. Everything is deployed with proper security and monitoring

**Time**: 5-10 minutes, consistent, secure, and documented.

## Architecture Benefits
- **Security**: Secrets stored in Key Vault, accessed via Managed Identity
- **Monitoring**: Application Insights provides performance metrics and logging
- **Scalability**: App Service can scale based on demand
- **High Availability**: Azure manages database backups and availability
- **DevOps Ready**: Staging slot enables blue-green deployments
- **Cost Effective**: Uses appropriate SKUs for demo purposes

## How to Run This Demo

### Local Deployment
```bash
# Navigate to the demo directory
cd demo3-app-deployment

# Initialize Terraform
terraform init

# Plan the deployment (provide a secure database password)
terraform plan -var="db_admin_password=SecurePassword123!"

# Deploy the resources
terraform apply -var="db_admin_password=SecurePassword123!"

# View outputs
terraform output

# Clean up when done
terraform destroy -var="db_admin_password=SecurePassword123!"
```

### GitHub Actions Deployment
Use the GitHub Actions workflow for this demo by:
1. Go to Actions tab in GitHub
2. Select "Demo 3: Full App Deployment"
3. Click "Run workflow"
4. Provide a secure database password
5. Choose App Service SKU (F1 for free tier)
6. Choose "deploy", "plan", or "destroy" action

## After Deployment
1. **Production App**: Visit the main App Service URL
2. **Staging Environment**: Test features in the staging slot
3. **Monitoring**: Check Application Insights for metrics
4. **Database**: Connect to SQL database using provided FQDN
5. **Secrets**: Verify Key Vault contains database connection string

## Production Considerations
- **App Service SKU**: Use B1 or higher for production workloads
- **Database**: Consider higher SKUs and backup strategies
- **Security**: Implement network restrictions and RBAC
- **Monitoring**: Set up alerts and log analytics
- **Deployment**: Use CI/CD pipelines for code deployment
- **SSL**: Configure custom domains and SSL certificates

## Cost Optimization
- **Free Tier**: F1 App Service is free but has limitations
- **Database**: B_Standard_B1ms is cost-effective for small workloads
- **Auto-shutdown**: Consider Azure DevTest Labs for development
- **Reserved Instances**: For production, consider reserved pricing

## Learning Points
- **Platform as a Service (PaaS)**: Focus on application, not infrastructure
- **Managed Identity**: Secure service-to-service authentication
- **Key Vault Integration**: Centralized secrets management
- **Application Insights**: Comprehensive application monitoring
- **Deployment Slots**: Safe deployment practices
- **Database Security**: Connection string management and firewall rules

## Troubleshooting
- **App Won't Start**: Check Application Insights logs
- **Database Connection**: Verify Key Vault access policy
- **Permissions**: Ensure service principal has required roles
- **Slot Swapping**: Use Azure CLI or Portal for production deployment

## Next Steps
- Deploy your own .NET application code
- Set up CI/CD pipeline using GitHub Actions
- Configure custom domain and SSL certificate
- Implement Azure Active Directory authentication
- Set up automated testing and monitoring alerts
- Explore Azure Container Apps for containerized workloads

## Security Features Demonstrated
- ✅ Managed Identity for service authentication
- ✅ Key Vault for secrets management
- ✅ Database firewall configuration
- ✅ HTTPS-only web application
- ✅ Isolated staging environment
- ✅ Application-level monitoring and logging