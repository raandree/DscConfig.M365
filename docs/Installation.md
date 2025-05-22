# Installation

This guide outlines how to install and set up DscConfig.M365 for use in your environment.

> **Important:** DscConfig.M365 is designed to work with [Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop) and is not intended for standalone use. Please ensure you have Microsoft365DscWorkshop set up as well.

## Prerequisites

Before installing DscConfig.M365, ensure you have the following prerequisites:

1. Windows PowerShell 5.1 or PowerShell 7+ (check the `build.yaml` for version requirements)
2. Administrative access to your system
3. Internet access to download dependencies from the PowerShell Gallery

## Installation Steps

> **Note:** Typically, you don't need to install DscConfig.M365 directly. It is automatically downloaded by Microsoft365DscWorkshop via PSDepend as it's listed as a requirement in the `RequiredModules.psd1` file.

### Option 1: As Part of Microsoft365DscWorkshop

The recommended way to use DscConfig.M365 is through Microsoft365DscWorkshop:

```powershell
# Clone the Microsoft365DscWorkshop repository
git clone https://github.com/raandree/Microsoft365DscWorkshop.git
cd Microsoft365DscWorkshop

# Run the bootstrap script which will download all required modules including DscConfig.M365
./Build.ps1 -ResolveDependency
```

### Option 2: Manual Installation

1. Clone the repository:

```powershell
git clone https://github.com/dsccommunity/DscConfig.M365.git
```

2. Navigate to the repository directory:

```powershell
cd DscConfig.M365
```

3. Install dependencies and build the module:

```powershell
# Install required modules and build the project
.\Build.ps1 -ResolveDependency -Tasks Build
```

4. Consider setting up Microsoft365DscWorkshop which is required for using DscConfig.M365 in a production environment.

## Module Dependencies

DscConfig.M365 depends on:

- **Microsoft365DSC**: The underlying DSC resource module for Microsoft 365 (version specified in `RequiredModules.psd1`)
- **Microsoft365DscWorkshop**: The deployment framework that automatically includes DscConfig.M365 through its dependency management
- Other supporting modules (specified in `RequiredModules.psd1`):
  - Datum
  - DscBuildHelpers
  - PSDesiredStateConfiguration
  - Various build tools (InvokeBuild, PSScriptAnalyzer, etc.)

## Verification

To verify that the module is accessible through Microsoft365DscWorkshop or has been built correctly in your local repository:

```powershell
# Import the module
Import-Module DscConfig.M365 -Verbose

# List available composite resources
Get-DscResource -Module DscConfig.M365
```

You should see a list of composite resources prefixed with 'c' (e.g., cAADApplication, cEXOAcceptedDomain)

## Next Steps

Refer to the [Integration with Microsoft365DscWorkshop](Integration.md) documentation to learn how to use DscConfig.M365 with Microsoft365DscWorkshop, and the [Usage](Usage.md) documentation for details on how to use the composite resources.
