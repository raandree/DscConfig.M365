# Examples

This document provides practical examples of using DscConfig.M365 composite resources for Microsoft 365 management.

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
                    Identity           = 'contoso.com'
                    DomainType         = 'Authoritative'
                    MatchSubDomains    = $false
                    OutboundOnly       = $false
                    Default            = $true
                    Ensure             = 'Present'
                },
                @{
                    Identity           = 'contoso.mail.onmicrosoft.com'
                    DomainType         = 'Authoritative'
                    MatchSubDomains    = $false
                    OutboundOnly       = $false
                    Default            = $false
                    Ensure             = 'Present'
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
                    DisplayName      = 'Require MFA for Admin Roles'
                    State            = 'Enabled'
                    Conditions       = @{
                        Users = @{
                            IncludeGroups = @('AdminRoles')
                        }
                    }
                    GrantControls    = @{
                        Operator = 'OR'
                        BuiltInControls = @('MFA')
                    }
                    Ensure           = 'Present'
                }
            )
            TenantId              = 'contoso.onmicrosoft.com'
            ApplicationId         = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
            CertificateThumbprint = '1234567890ABCDEF1234567890ABCDEF12345678'
        }
    }
}
```

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

```yaml
# Configuration data in YAML format for Microsoft365DscWorkshop
configurations:
  - M365:  # Configuration document name
      DscResourcesToExecute:
        cAADSecurityDefaults:
          TenantId: contoso.onmicrosoft.com
          Credential: "[ENC=PE9ianMgVmVyc2lvbj0iMS4xLjAu...encoded credential...==]"
          IsSingleInstance: 'Yes'
          IsEnabled: true

        cEXOAcceptedDomain:
          TenantId: contoso.onmicrosoft.com
          Credential: "[ENC=PE9ianMgVmVyc2lvbj0iMS4xLjAu...encoded credential...==]"
          Items:
            - Identity: 'contoso.com'
              DomainType: 'Authoritative'
              MatchSubDomains: false
              OutboundOnly: false
              Default: true
              Ensure: 'Present'
            - Identity: 'contoso.mail.onmicrosoft.com'
              DomainType: 'Authoritative'
              MatchSubDomains: false
              OutboundOnly: false
              Default: false
              Ensure: 'Present'
```

> Note: Please refer to the [configuration data for the Pester](../tests//Unit//DSCResources//Assets/Config/) tests for further examples

### Complete Example with Microsoft365DscWorkshop

For a complete example of how to use DscConfig.M365 with Microsoft365DscWorkshop, refer to the examples in the [Microsoft365DscWorkshop repository](https://github.com/raandree/Microsoft365DscWorkshop).

## Best Practices

1. **Use Parameter Values for Credentials**: Always pass credentials as parameters rather than hardcoding them.
2. **Use Single Connection Parameters**: When configuring multiple resources, use the same credential or authentication method for all resources.
3. **Organize by Workload**: Group resources by workload for better readability.
4. **Use Array Resources Effectively**: Combine related items into a single array resource rather than creating multiple instances of the same resource.
5. **Test Configurations**: Always test configurations in a test environment before applying them to production.

For more examples and use cases, see the test configurations in the [tests directory](https://github.com/dsccommunity/DscConfig.M365/tree/main/tests/Unit/DSCResources/Assets/Config) or refer to the [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop).
