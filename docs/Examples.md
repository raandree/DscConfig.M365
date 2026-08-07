# Examples

This document provides practical examples of using DscConfig.M365 composite resources for Microsoft 365 management.

If you are looking for a walkthrough rather than snippets, see
[Getting Started](GettingStarted.md).

## Basic Configuration Examples

### Azure Active Directory Security Defaults

```powershell
configuration AADSecurityDefaults_Example {
    param (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cAADSecurityDefaults SecurityDefaults {
            IsSingleInstance = 'Yes'
            IsEnabled        = $true
            TenantId         = 'contoso.onmicrosoft.com'
            Credential       = $Credential
        }
    }
}
```

### Exchange Online Accepted Domains

```powershell
configuration EXOAcceptedDomains_Example {
    param (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cEXOAcceptedDomain AcceptedDomains {
            Items = @(
                @{
                    Identity        = 'contoso.com'
                    DomainType      = 'Authoritative'
                    MatchSubDomains = $false
                    OutboundOnly    = $false
                    Ensure          = 'Present'
                },
                @{
                    Identity        = 'contoso.mail.onmicrosoft.com'
                    DomainType      = 'Authoritative'
                    MatchSubDomains = $false
                    OutboundOnly    = $false
                    Ensure          = 'Present'
                }
            )
            TenantId   = 'contoso.onmicrosoft.com'
            Credential = $Credential
        }
    }
}
```

### Managing AAD Groups

```powershell
configuration AADGroups_Example {
    param (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cAADGroup Groups {
            Items = @(
                @{
                    DisplayName       = 'Marketing'
                    Description       = 'Marketing Team'
                    SecurityEnabled   = $true
                    MailEnabled       = $true
                    MailNickname      = 'marketing'
                    GroupTypes        = @()
                    Ensure            = 'Present'
                },
                @{
                    DisplayName       = 'Sales'
                    Description       = 'Sales Team'
                    SecurityEnabled   = $true
                    MailEnabled       = $true
                    MailNickname      = 'sales'
                    GroupTypes        = @()
                    Ensure            = 'Present'
                }
            )
            TenantId   = 'contoso.onmicrosoft.com'
            Credential = $Credential
        }
    }
}
```

## Authentication Examples

### Using Certificate-Based Authentication

```powershell
configuration CertAuth_Example {
    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cAADConditionalAccessPolicy Policies {
            Items = @(
                @{
                    DisplayName            = 'Require MFA for Admin Roles'
                    State                  = 'enabled'
                    IncludeRoles           = @('Global Administrator')
                    IncludeApplications    = @('All')
                    ClientAppTypes         = @('All')
                    BuiltInControls        = @('Mfa')
                    GrantControlOperator   = 'OR'
                    Ensure                 = 'Present'
                }
            )
            TenantId              = 'contoso.onmicrosoft.com'
            ApplicationId         = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
            CertificateThumbprint = '1234567890ABCDEF1234567890ABCDEF12345678'
        }
    }
}
```

> **Note:** The properties of a Microsoft365DSC resource are flat. Conditions and
> controls are individual properties such as `IncludeRoles` and `BuiltInControls`
> rather than nested objects. Run
> `Get-DscResource -Module Microsoft365DSC -Name AADConditionalAccessPolicy -Syntax`
> to see the full set, or read the syntax comment in the generated
> `cAADConditionalAccessPolicy.schema.psm1`.

### Using Managed Identity

```powershell
configuration ManagedIdentity_Example {
    Import-DscResource -ModuleName DscConfig.M365

    node localhost {
        cEXOTransportRule Rules {
            Items = @(
                @{
                    Name                          = 'External Email Warning'
                    Comments                      = 'Add warning to external emails'
                    Enabled                       = $true
                    FromScope                     = 'NotInOrganization'
                    SentToScope                   = 'InOrganization'
                    ApplyHtmlDisclaimerLocation   = 'Prepend'
                    ApplyHtmlDisclaimerText       = '<p>[External Email Warning]</p>'
                    Ensure                        = 'Present'
                }
            )
            TenantId        = 'contoso.onmicrosoft.com'
            ManagedIdentity = $true
        }
    }
}
```

## Integration with Microsoft365DscWorkshop Examples

### YAML Configuration Example

In Microsoft365DscWorkshop each composite resource gets its own YAML file, named
after the composite resource, and the content of the file is the parameter set of
that composite resource.

`source/1-AllTenantsConfig/AzureAd/cAADSecurityDefaults.yml`:

```yaml
IsSingleInstance: 'Yes'
IsEnabled: false
TenantId: '[x={ $azBuildParameters."$($Node.Environment)".AzTenantName }=]'
ManagedIdentity: true
```

`source/1-AllTenantsConfig/Exchange/cEXOAcceptedDomain.yml`:

```yaml
Items:
  - Identity: contoso.com
    DomainType: Authoritative
    MatchSubDomains: false
    OutboundOnly: false
    Ensure: Present
  - Identity: contoso.mail.onmicrosoft.com
    DomainType: Authoritative
    MatchSubDomains: false
    OutboundOnly: false
    Ensure: Present
```

Both resources are only enacted when they are listed in the `Configurations.yml`
of their folder:

```yaml
- cAADSecurityDefaults
```

> Note: Please refer to the
> [configuration data for the Pester tests](../tests/Unit/DSCResources/Assets/Config/)
> for further examples.

### Complete Example with Microsoft365DscWorkshop

For a complete example of how to use DscConfig.M365 with
Microsoft365DscWorkshop, refer to the
[Microsoft365DscWorkshop repository](https://github.com/dsccommunity/Microsoft365DscWorkshop)
and to [Integration with Microsoft365DscWorkshop](Integration.md).

## Best Practices

1. **Use Parameter Values for Credentials**: Always pass credentials as parameters rather than hardcoding them.
1. **Use Single Connection Parameters**: Set the connection parameters once on
   the composite resource instead of repeating them on every item.
1. **Organize by Workload**: Group resources by workload for better readability.
1. **Use Array Resources Effectively**: Combine related items into a single array resource rather than creating multiple instances of the same resource.
1. **Test Configurations**: Always test configurations in a test environment before applying them to production.

For more examples and use cases, see the test configurations in the [tests directory](https://github.com/dsccommunity/DscConfig.M365/tree/main/tests/Unit/DSCResources/Assets/Config) or refer to the [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop).
