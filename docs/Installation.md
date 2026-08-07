# Installation

This guide outlines how to install and set up DscConfig.M365 for use in your environment.

> **Important:** DscConfig.M365 is designed to work with [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop) and is not intended for standalone use. Please ensure you have Microsoft365DscWorkshop set up as well.

If you are new to this module, start with [Getting Started](GettingStarted.md).

## Prerequisites

Before installing DscConfig.M365, ensure you have the following prerequisites:

1. Windows. The build compiles MOF files and queries `Get-DscResource` against
   Microsoft365DSC.
1. PowerShell 7 or later. The `TestPowerShell7` build task is the first step of
   the `build` workflow and fails on Windows PowerShell 5.1.
1. Administrative access to your system.
1. Internet access to download dependencies from the PowerShell Gallery.

## Installation Steps

> **Note:** Typically, you don't need to install DscConfig.M365 directly. It is automatically downloaded by Microsoft365DscWorkshop via PSDepend as it's listed as a requirement in the `RequiredModules.psd1` file.

### Option 1: As Part of Microsoft365DscWorkshop

The recommended way to use DscConfig.M365 is through Microsoft365DscWorkshop:

```powershell
# Clone the Microsoft365DscWorkshop repository
git clone https://github.com/dsccommunity/Microsoft365DscWorkshop.git
cd Microsoft365DscWorkshop

# Restore all required modules including DscConfig.M365
./build.ps1 -UseModuleFast -ResolveDependency
```

The module is restored to `output\RequiredModules\DscConfig.M365`. The version
is pinned in the workshop's own `RequiredModules.psd1`.

### Option 2: Build from Source

Use this option when you want to change or extend the module:

1. Clone the repository:

```powershell
git clone https://github.com/dsccommunity/DscConfig.M365.git
```

1. Navigate to the repository directory:

```powershell
cd DscConfig.M365
```

1. Install dependencies and build the module:

```powershell
# Install required modules and build the project
.\build.ps1 -ResolveDependency -Tasks build
```

The built module is written to `output\Module\DscConfig.M365\<version>`. The
composite resources themselves are generated into `source\DSCResources` on every
build and are excluded from source control.

1. Consider setting up Microsoft365DscWorkshop, which is required for using
   DscConfig.M365 in a production environment.

## Module Dependencies

DscConfig.M365 depends on:

- **Microsoft365DSC**: The underlying DSC resource module for Microsoft 365. The
  version is pinned in `RequiredModules.psd1` and determines which composite
  resources can be generated.
- **DscBuildHelpers**: Supplies `Get-DscResourceProperty`, used by the code
  generator, and `Get-DscSplattedResource`, which the generated composite
  resources call at configuration time.
- **PSDesiredStateConfiguration**: Imported by every generated composite resource.
- **Datum**: Used by the unit tests to load the sample configuration data.
- Build tooling declared in `RequiredModules.psd1`, including Sampler,
  InvokeBuild, ModuleBuilder, Pester, PSScriptAnalyzer and DscResource.Test.

Microsoft365DscWorkshop is not a dependency of this module. It is the consumer
that declares DscConfig.M365 in its own `RequiredModules.psd1`.

## Verification

To verify that the module is accessible through Microsoft365DscWorkshop, or that
it was built correctly in your local repository:

```powershell
# List available composite resources
Get-DscResource -Module DscConfig.M365
```

You should see a list of composite resources prefixed with 'c', for example
`cAADGroup` and `cEXOAcceptedDomain`.

> **Note:** `Import-Module DscConfig.M365` is not required. The module ships DSC
> composite resources rather than functions, and a DSC configuration imports them
> with `Import-DscResource -ModuleName DscConfig.M365`.

## Next Steps

- [Getting Started](GettingStarted.md) walks through the first configuration.
- [Usage](Usage.md) explains the composite resource parameters.
- [Integration with Microsoft365DscWorkshop](Integration.md) describes how the
  deployment framework consumes this module.
