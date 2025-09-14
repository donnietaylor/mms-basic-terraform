# Demo 2 VM Extension Troubleshooting

## Issue Fixed: VMExtensionProvisioningError - Script File Not Found

### Problem Description
The demo2 VM deployment was failing with a `VMExtensionProvisioningError` indicating:
- Error message: "The argument 'setup-iis.ps1' to the -File parameter does not exist"
- Non-zero exit code of '-196608'
- PowerShell complaining that the script file could not be found

### Root Cause Analysis
The issue was in the Azure Custom Script Extension configuration in `main.tf`:

**Problematic Configuration:**
```hcl
protected_settings = jsonencode({
  "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File setup-iis.ps1",
  "script"           = base64encode(file("${path.module}/setup-iis.ps1"))
})
```

**The Problem:** When using the `script` parameter with base64-encoded content, the script is uploaded to Azure but not saved as a named file on the VM filesystem. The `commandToExecute` was trying to reference `setup-iis.ps1` as if it were a file, but it doesn't exist in that location.

### Solution Implemented

**Fixed Configuration:**
```hcl
protected_settings = jsonencode({
  "script" = base64encode(file("${path.module}/setup-iis.ps1"))
})
```

**Why This Works:** When only the `script` parameter is provided with base64-encoded PowerShell content, Azure automatically executes the script without needing a separate `commandToExecute` directive.

### Key Technical Details

1. **Azure Custom Script Extension Behavior**: 
   - With `script` parameter only: Azure executes the base64-decoded content directly
   - With `fileUris` + `commandToExecute`: Files are downloaded and can be referenced by name
   - Mixing `script` + `commandToExecute` with file references causes this exact error

2. **The Fix is Minimal**: 
   - Removed the conflicting `commandToExecute` parameter
   - Kept the `script` parameter with base64-encoded content
   - No changes needed to the PowerShell script itself

### Testing the Fix

The fix addresses the specific error:
- ✅ Eliminates the "file does not exist" error
- ✅ Allows the PowerShell script to execute properly
- ✅ Maintains the same functionality with cleaner configuration
- ✅ Uses Azure best practices for embedded script execution

### Alternative Approaches (Not Used)

We could have used these approaches, but they require more changes:

1. **FileUris Approach** (more complex):
```hcl
settings = jsonencode({
  "fileUris" = ["https://raw.githubusercontent.com/your-repo/setup-iis.ps1"]
})
protected_settings = jsonencode({
  "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File setup-iis.ps1"
})
```

2. **Inline Command Approach** (less maintainable):
```hcl
protected_settings = jsonencode({
  "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -Command \"& { ${replace(file("${path.module}/setup-iis.ps1"), "\"", "`\"" )} }\""
})
```

### Benefits of the Chosen Fix

1. **Minimal Changes**: Only removed conflicting parameters
2. **Secure**: Script content remains in protected_settings
3. **Maintainable**: Script stays in separate file for version control
4. **Reliable**: Uses Azure's intended pattern for embedded scripts
5. **Self-Contained**: No external dependencies or URLs needed

### Prevention

To avoid similar issues:
- Use either `script` parameter alone OR `fileUris` + `commandToExecute`
- Never mix embedded script content with file-based command execution
- Test VM extensions in isolation when troubleshooting
- Check Azure documentation for extension-specific parameter patterns