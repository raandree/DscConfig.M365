# Available Resources

This document explains which composite DSC resources the DscConfig.M365 module
contains, how that set is determined and how to list it. The resources are
generated during the build from the resources available in Microsoft365DSC, so
this page deliberately does not hard-code a list that would go stale with every
Microsoft365DSC release.

## Resource Naming Convention

All composite resources in DscConfig.M365 follow a naming convention:

- Prefixed with 'c' (for composite)
- Followed by the original Microsoft365DSC resource name
- Example: `AADApplication` in Microsoft365DSC becomes `cAADApplication` in DscConfig.M365

The workload prefix of the underlying resource is preserved, so the composite
resources group naturally by workload: `cAAD*` for Entra ID, `cEXO*` for Exchange
Online, `cIntune*` for Intune, `cSPO*` for SharePoint Online, `cSC*` for Security
and Compliance, `cTeams*` for Teams and `cO365*` for tenant-wide Office 365
settings.

## Which Resources Are Generated

The set is driven by the sample configuration data in
`tests/Unit/DSCResources/Assets/Config`. Every file in that folder is named
`c<ResourceName>.yml`, and the build generates a composite resource for each
matching Microsoft365DSC resource. Entries that no longer exist in the pinned
Microsoft365DSC version are silently skipped.

If the folder is empty, the build falls back to generating a composite resource
for every Microsoft365DSC resource.

This coupling is intentional: a composite resource is only shipped when there is
configuration data that proves it compiles to a MOF file.

## Resource Types

The resources are categorized into two types:

1. **Scalar Resources**: Resources that expose an `IsSingleInstance` property.
   The composite resource mirrors the parameters of the underlying resource one
   to one. Example: `cAADSecurityDefaults`, `cSPOTenantSettings`.
1. **Array Resources**: Every other resource. The composite resource takes a
   single `Items` array of hashtables plus the shared connection parameters.
   Example: `cAADGroup`, `cEXOTransportRule`.

## Resource Generation

These resources are generated during the build process from the Microsoft365DSC
resources. The generation process:

1. Reads the resource names from `tests/Unit/DSCResources/Assets/Config`
1. Determines if each resource is a scalar or array type
1. Creates corresponding composite resources with appropriate parameters
1. Adds the connection parameters (`TenantId`, `ManagedIdentity`, `Credential`,
   `CertificateThumbprint`, `ApplicationSecret`, `ApplicationId`,
   `AccessTokens`) to each array composite resource
1. Embeds the syntax block of the underlying Microsoft365DSC resource as a
   comment so the available properties stay discoverable

The generated resources are not stored in the repository. They are written to
`source/DSCResources` on every build and excluded by `.gitignore`.

## Viewing Available Resources

To see the list of composite resources available in your current installation:

```powershell
Get-DscResource -Module DscConfig.M365 | Select-Object -ExpandProperty Name
```

To group them by workload:

```powershell
Get-DscResource -Module DscConfig.M365 |
    Group-Object { $_.Name -replace '^c([A-Z]+).*', '$1' } |
    Select-Object Name, Count
```

To see the parameters of a single composite resource:

```powershell
Get-DscResource -Module DscConfig.M365 -Name cAADGroup -Syntax
```

## Adding a Resource

1. Create `tests/Unit/DSCResources/Assets/Config/c<ResourceName>.yml` with sample
   configuration data for the Microsoft365DSC resource.
1. Run `./build.ps1 -Tasks build,test`.
1. Confirm that `output/MOF/localhost_c<ResourceName>.mof` was produced.

See [Getting Started](GettingStarted.md) for the full workflow.

## Resource Documentation

For detailed documentation about each resource's parameters and usage, refer to
the [Microsoft365DSC documentation](https://microsoft365dsc.com/resources/). The
composite resources mirror the underlying Microsoft365DSC resources while
simplifying their usage.

## See Also

- [Getting Started](GettingStarted.md)
- [Usage](Usage.md)
- [Examples](Examples.md)
