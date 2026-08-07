# Integration with Microsoft365DscWorkshop

This document explains how DscConfig.M365 integrates with Microsoft365DscWorkshop and why both projects are essential for a complete Microsoft 365 configuration management solution.

## The Three-Tier Architecture

The complete solution for Microsoft 365 configuration management consists of three layers:

1. **Microsoft365DSC** - The foundation layer providing the DSC resources that interact with Microsoft 365 APIs
1. **DscConfig.M365** (this project) - The abstraction layer creating composite resources with simplified interfaces
1. **Microsoft365DscWorkshop** - The orchestration layer that consumes these composite resources for deployment

Each layer serves a specific purpose, and they work together to provide a comprehensive configuration management solution.

## Why Microsoft365DscWorkshop Is Required

DscConfig.M365 is designed to work with Microsoft365DscWorkshop for several important reasons:

1. **Deployment Framework**: Microsoft365DscWorkshop provides the deployment infrastructure and orchestration mechanisms needed to apply configurations effectively.

1. **Environment Management**: Microsoft365DscWorkshop handles environment-specific configurations and separates them from the resource definitions.

1. **Configuration Data Management**: Microsoft365DscWorkshop implements the Datum pattern for managing configuration data hierarchies.

1. **CI/CD Integration**: Microsoft365DscWorkshop provides the scaffolding for continuous integration and deployment of Microsoft 365 configurations.

## Setting Up the Complete Solution

To implement a complete solution, you typically just need to set up Microsoft365DscWorkshop, which automatically includes DscConfig.M365:

1. Clone and set up Microsoft365DscWorkshop:

```powershell
# Clone the Microsoft365DscWorkshop repository
git clone https://github.com/dsccommunity/Microsoft365DscWorkshop.git
cd Microsoft365DscWorkshop

# Restore all dependencies including DscConfig.M365
./build.ps1 -UseModuleFast -ResolveDependency
```

For a step-by-step walkthrough, see [Getting Started](GettingStarted.md).

## How Microsoft365DscWorkshop Consumes This Module

Two files in Microsoft365DscWorkshop reference DscConfig.M365.

`RequiredModules.psd1` pins the version that is restored into
`output/RequiredModules`:

```powershell
# Composites
'DscConfig.M365' = '0.7.0-preview0001'
'DscConfig.Demo' = 'latest'
```

`build.yaml` registers it as a composite resource module so the DSC pipeline
imports it and ships it with the artifacts:

```yaml
Sampler.DscPipeline:
  DscCompositeResourceModules:
  - PSDesiredStateConfiguration
  - DscConfig.M365
  - DscConfig.Demo
```

You do not need to install or reference DscConfig.M365 separately.

## Workflow Overview

The typical workflow when using these projects together:

1. **Define Resources**: Use DscConfig.M365 composite resources to define Microsoft 365 configurations
1. **Organize Configuration Data**: Structure your configuration data in Microsoft365DscWorkshop
1. **Build & Test**: Use Microsoft365DscWorkshop build pipeline to compile and test configurations
1. **Deploy**: Deploy configurations to your Microsoft 365 tenants using Microsoft365DscWorkshop

## Where the Configuration Data Lives

Microsoft365DscWorkshop stores its configuration data in `source/` as a
[Datum](https://github.com/gaelcolas/Datum) hierarchy that is resolved by
`source/Datum.yml`:

```text
source/
  Datum.yml                        # hierarchy, merge behavior, Datum handlers
  Global/
    Azure.yml                      # tenants, environments and identities
    ProjectSettings.yml            # Azure DevOps project settings
  BuildAgents/<Environment>/       # node definitions, one per tenant
  2-EnvironmentConfig/<Environment>/<Workload>/
  1-AllTenantsConfig/<Workload>/   # the baseline shared by all tenants
  0-DscConfiguration/LcmConfiguration/
```

`<Workload>` is `AzureAd`, `Exchange`, `SharePoint` or `Purview`. Values
resolved from a more specific layer override the baseline, which is how a Dev
tenant can deviate from Test and Prod in a controlled way.

## Example Integration

Each composite resource gets its own YAML file, and the **file name is the
composite resource name**. The content of the file is the parameter set of the
composite resource.

`source/1-AllTenantsConfig/AzureAd/cAADGroup.yml`:

```yaml
Items:
  - MailNickname: Marketing
    DisplayName: Marketing
    Description: Marketing department
    MailEnabled: false
    SecurityEnabled: true
    Ensure: Present
  - MailNickname: Sales
    DisplayName: Sales
    Description: Sales department
    MailEnabled: false
    SecurityEnabled: true
    Ensure: Present
```

A composite resource is only enacted when it is listed in the `Configurations.yml`
of its folder.

`source/1-AllTenantsConfig/AzureAd/Configurations.yml`:

```yaml
- cAADNamedLocationPolicy
- cAADGroup
- cAADAuthorizationPolicy
- cAADGroupsSettings
- cAADSecurityDefaults
```

### Resolving Values at Build Time

The `Datum.InvokeCommand` handler evaluates `[x={ ... }=]` expressions during the
build. Microsoft365DscWorkshop uses it to inject the tenant of the current
environment instead of hard-coding it per file:

```yaml
Items:
  - MailNickname: Marketing
    DisplayName: Marketing
    MailEnabled: false
    SecurityEnabled: true
    TenantId: '[x={ $azBuildParameters."$($Node.Environment)".AzTenantName }=]'
    ManagedIdentity: true
    Ensure: Present
```

### Controlling How Items Merge

Because `Items` is an array, `source/Datum.yml` declares how the layers are
combined. Without this, a more specific layer replaces the whole array instead of
merging into it:

```yaml
lookup_options:
  Configurations:
    merge_basetype_array: Unique

  cAADGroup:
    merge_hash: deep
  cAADGroup\Items:
    merge_hash_array: UniqueKeyValTuples
    merge_options:
      tuple_keys:
        - MailNickname
```

Add an entry like this for every composite resource whose items should merge
across layers, and pick `tuple_keys` that identify an item uniquely.

## Verifying the Result

Run the build in the Microsoft365DscWorkshop repository and review the artifacts
before enacting anything:

```powershell
./build.ps1
```

- `output/RSOP` — the resolved configuration data per node, which shows exactly
  what survived the Datum merge.
- `output/MOF` — the compiled configuration that the Local Configuration Manager
  enacts against the tenant.

## Additional Resources

- [Getting Started](GettingStarted.md)
- [Usage](Usage.md)
- [Microsoft365DSC GitHub Repository](https://github.com/microsoft/Microsoft365DSC)
- [Microsoft365DscWorkshop GitHub Repository](https://github.com/dsccommunity/Microsoft365DscWorkshop)
- [Microsoft365DscWorkshop getting started guide](https://github.com/dsccommunity/Microsoft365DscWorkshop/blob/main/docs/GettingStarted.md)
- [Datum](https://github.com/gaelcolas/Datum)
- [PowerShell DSC Documentation](https://learn.microsoft.com/en-us/powershell/dsc/overview)
