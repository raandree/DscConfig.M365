# Usage

This guide provides information on how to use DscConfig.M365 for managing Microsoft 365 resources using PowerShell DSC.

> **Important:** DscConfig.M365 is designed to be used with [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop) and is not intended as a standalone solution. For a complete implementation, please refer to the Microsoft365DscWorkshop documentation.

If you have not used this module before, read
[Getting Started](GettingStarted.md) first.

## Architecture Overview

DscConfig.M365 is designed to work as part of a three-tier architecture:

1. **Microsoft365DSC** (base layer): Provides the fundamental DSC resources for Microsoft 365
1. **DscConfig.M365** (middle layer): Creates composite resources with simplified interfaces
1. **Microsoft365DscWorkshop** (top layer): Deployment framework for managing configurations

## Composite Resource Types

DscConfig.M365 generates two types of composite resources:

1. **Scalar Resources**: For singleton resources (with `IsSingleInstance` property)
   - Used for global settings or tenant-wide configurations
   - Example: `cAADSecurityDefaults`, `cSPOTenantSettings`

1. **Array Resources**: For resources that can have multiple instances
   - Used for configuring collections of objects
   - Example: `cAADApplication`, `cEXOTransportRule`

## Basic Usage

### 1. Import the composite resources

A DSC configuration imports the composite resources like any other DSC resource
module. `Import-Module` is not needed, because this module ships composite
resources rather than functions:

```powershell
Import-DscResource -ModuleName DscConfig.M365
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

A scalar composite resource exposes the parameters of the underlying
Microsoft365DSC resource one to one, including its authentication parameters.

### 3. Working with Array Resources

Array resources allow you to configure multiple instances using arrays:

```powershell
configuration MyM365Config {
    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cAADGroup Groups {
            Items = @(
                @{
                    DisplayName     = 'Marketing'
                    MailNickname    = 'marketing'
                    MailEnabled     = $false
                    SecurityEnabled = $true
                },
                @{
                    DisplayName     = 'Sales'
                    MailNickname    = 'sales'
                    MailEnabled     = $false
                    SecurityEnabled = $true
                }
            )
            TenantId   = 'contoso.onmicrosoft.com'
            Credential = $credentialObject
        }
    }
}
```

An array composite resource does not expose the parameters of the underlying
resource. It takes a single `Items` array of hashtables, and each hashtable is
splatted onto one instance of the Microsoft365DSC resource. The instance name is
derived from the key properties of the resource, so you never name instances
yourself.

## Authentication Methods

Every array composite resource carries the same set of connection parameters:

| Parameter | Type |
| --- | --- |
| `TenantId` | `string` |
| `ManagedIdentity` | `bool` |
| `Credential` | `pscredential` |
| `CertificateThumbprint` | `string` |
| `ApplicationSecret` | `pscredential` |
| `ApplicationId` | `string` |
| `AccessTokens` | `string[]` |

Set them once on the composite resource and they are pushed down to every item
that does not set them itself:

```powershell
# Using credential-based authentication
cAADGroup Groups {
    Items      = @(...)
    TenantId   = 'contoso.onmicrosoft.com'
    Credential = $credentialObject
}

# Using certificate-based authentication
cAADGroup Groups {
    Items                 = @(...)
    TenantId              = 'contoso.onmicrosoft.com'
    CertificateThumbprint = '1234567890ABCDEF1234567890ABCDEF12345678'
    ApplicationId         = '00000000-0000-0000-0000-000000000000'
}

# Using an application secret
cAADGroup Groups {
    Items             = @(...)
    TenantId          = 'contoso.onmicrosoft.com'
    ApplicationId     = '00000000-0000-0000-0000-000000000000'
    ApplicationSecret = $secretObject
}

# Using managed identity
cAADGroup Groups {
    Items           = @(...)
    TenantId        = 'contoso.onmicrosoft.com'
    ManagedIdentity = $true
}
```

> **Note:** The push-down is generated only for resources that expose an `Ensure`
> property. For the few resources without it, set the connection parameters on
> each item in the `Items` array.

## Integration with Microsoft365DscWorkshop

When using DscConfig.M365 with the Microsoft365DscWorkshop framework, you define
your configurations in YAML instead of PowerShell. Each composite resource gets
its own file, and the file name is the composite resource name.

`source/1-AllTenantsConfig/AzureAd/cAADGroup.yml`:

```yaml
Items:
  - MailNickname: Marketing
    DisplayName: Marketing
    Description: Marketing department
    MailEnabled: false
    SecurityEnabled: true
    TenantId: '[x={ $azBuildParameters."$($Node.Environment)".AzTenantName }=]'
    ManagedIdentity: true
    Ensure: Present
  - MailNickname: Sales
    DisplayName: Sales
    Description: Sales department
    MailEnabled: false
    SecurityEnabled: true
    TenantId: '[x={ $azBuildParameters."$($Node.Environment)".AzTenantName }=]'
    ManagedIdentity: true
    Ensure: Present
```

The composite resource is enacted only when it is listed in the
`Configurations.yml` of the same folder:

```yaml
- cAADGroup
- cAADAuthorizationPolicy
- cAADSecurityDefaults
```

For details on the folder hierarchy, the `[x={ ... }=]` expressions and the merge
options in `source/Datum.yml`, see
[Integration with Microsoft365DscWorkshop](Integration.md).

## Examples

For more examples and detailed usage scenarios, see the [Examples](Examples.md) documentation.

## See Also

- [Getting Started](GettingStarted.md)
- [Available resources](Resources.md)
- [Microsoft365DSC resource reference](https://microsoft365dsc.com/resources/)
