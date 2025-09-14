# Install IIS web server
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Create custom HTML content
$html = @'
<!DOCTYPE html>
<html>
<head>
    <title>MMS Music Conference - Demo 2</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 40px; 
            background-color: #f0f8ff; 
        }
        .container { 
            max-width: 800px; 
            margin: auto; 
            background: white; 
            padding: 20px; 
            border-radius: 10px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
        }
        .header { 
            color: #2c3e50; 
            text-align: center; 
        }
        .demo-info { 
            background-color: #e8f4fd; 
            padding: 15px; 
            border-radius: 5px; 
            margin: 20px 0; 
        }
        .success { 
            color: #27ae60; 
            font-weight: bold; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🎵 MMS Music Conference 🎵</h1>
        <h2 class="header">Demo 2: Windows VM Deployment</h2>
        
        <div class="demo-info">
            <h3>🚀 Success! Your Windows VM is Running</h3>
            <p class="success">This web server was automatically deployed using Terraform!</p>
        </div>

        <h3>What was deployed:</h3>
        <ul>
            <li>✅ Virtual Network with custom subnet</li>
            <li>✅ Network Security Group with RDP and HTTP rules</li>
            <li>✅ Windows Server 2022 Virtual Machine</li>
            <li>✅ Public IP address</li>
            <li>✅ IIS web server (this page!)</li>
        </ul>

        <h3>From ClickOps to DevOps:</h3>
        <p>Instead of manually clicking through the Azure Portal to create a VM, network, and security rules, 
        everything was defined as code and deployed consistently!</p>

        <h3>Server Information:</h3>
        <ul>
            <li><strong>OS:</strong> Windows Server 2022</li>
            <li><strong>Web Server:</strong> IIS</li>
            <li><strong>Deployment Method:</strong> Terraform + PowerShell</li>
            <li><strong>Authentication:</strong> Username/Password (no SSH key required!)</li>
        </ul>

        <p><strong>Next:</strong> Try Demo 3 for a full application deployment with database!</p>
    </div>
</body>
</html>
'@

# Write the HTML file to IIS wwwroot
$html | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Encoding UTF8

# Start IIS service
Start-Service W3SVC