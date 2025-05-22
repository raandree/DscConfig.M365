# Usage

This guide provides information on how to use DscConfig.M365 for managing Microsoft 365 resources using PowerShell DSC.

> **Important:** DscConfig.M365 is designed to be used with [Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop) and is not intended as a standalone solution. For a complete implementation, please refer to the Microsoft365DscWorkshop documentation.

## Architecture Overview

DscConfig.M365 is designed to work as part of a three-tier architecture:

1. **Microsoft365DSC** (base layer): Provides the fundamental DSC resources for Microsoft 365
2. **DscConfig.M365** (middle layer): Creates composite resources with simplified interfaces
3. **Microsoft365DscWorkshop** (top layer): Deployment framework for managing configurations

## Composite Resource Types

DscConfig.M365 generates two types of composite resources:

1. **Scalar Resources**: For singleton resources (with `IsSingleInstance` property)
   - Used for global settings or tenant-wide configurations
   - Example: `cAADSecurityDefaults`, `cSPOTenantSettings`

2. **Array Resources**: For resources that can have multiple instances
   - Used for configuring collections of objects
   - Example: `cAADApplication`, `cEXOTransportRule`

## Basic Usage

### 1. Import the Module

```powershell
Import-Module DscConfig.M365
```

### 2. Working with Scalar Resources

Scalar resources typically represent global settings and have a single instance:

```powershell
configuration MyM365Config {
    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cAADSecurityDefaults SecurityDefaults {
            IsSingleInstance = 'Yes'
            IsEnabled        = $true
            TenantId         = 'contoso.onmicrosoft.com'
            Credential       = $credentialObject
        }
    }
}
```

### 3. Working with Array Resources

Array resources allow you to configure multiple instances using arrays:

```powershell
configuration MyM365Config {
    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cAADApplication Applications {
            Items = @(
                @{
                    DisplayName    = 'My App 1'
                    AvailableToOtherTenants = $false
                },
                @{
                    DisplayName    = 'My App 2'
                    AvailableToOtherTenants = $true
                }
            )
            TenantId      = 'contoso.onmicrosoft.com'
            Credential    = $credentialObject
        }
    }
}
```

## Authentication Methods

All composite resources support various authentication methods for Microsoft 365:

```powershell
# Using credential-based authentication
cAADGroup Groups {
    Items = @(...)
    TenantId   = 'contoso.onmicrosoft.com'
    Credential = $credentialObject
}

# Using certificate-based authentication
cAADGroup Groups {
    Items = @(...)
    TenantId              = 'contoso.onmicrosoft.com'
    CertificateThumbprint = '1234567890ABCDEF1234567890ABCDEF12345678'
    ApplicationId         = '00000000-0000-0000-0000-000000000000'
}

# Using managed identity
cAADGroup Groups {
    Items = @(...)
    TenantId         = 'contoso.onmicrosoft.com'
    ManagedIdentity  = $true
}
```

## Integration with Microsoft365DscWorkshop

When using DscConfig.M365 with the Microsoft365DscWorkshop framework, you'll define your configurations in YAML files:

```yaml
# Example YAML configuration for cAADGroup
cAADGroup:
  Items:
    - DisplayName: "Marketing Team"
      Description: "Marketing department team"
      MailEnabled: true
      SecurityEnabled: true
      MailNickname: "marketing"
      Ensure: "Present"
    - DisplayName: "Sales Team"
      Description: "Sales department team"
      MailEnabled: true
      SecurityEnabled: true
      MailNickname: "sales"
      Ensure: "Present"
```

For detailed information on integrating with Microsoft365DscWorkshop, see the [Microsoft365DscWorkshop repository](https://github.com/raandree/Microsoft365DscWorkshop).

## Examples

For more examples and detailed usage scenarios, see the [Examples](Examples.md) documentation.
