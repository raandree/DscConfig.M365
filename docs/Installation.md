# Installation

This guide outlines how to install and set up DscConfig.M365 for use in your environment.

> **Important:** DscConfig.M365 is designed to work with [Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop) and is not intended for standalone use. Please ensure you have Microsoft365DscWorkshop set up as well.

## Prerequisites

Before installing DscConfig.M365, ensure you have the following prerequisites:

1. Windows PowerShell 5.1 or PowerShell 7+ (check the `build.yaml` for version requirements)
2. Administrative access to your system
3. Internet access to download dependencies from the PowerShell Gallery

## Installation Steps

### Option 1: Install from PowerShell Gallery

```powershell
# Install the module from PowerShell Gallery
Install-Module -Name DscConfig.M365 -Scope CurrentUser
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

4. Set up Microsoft365DscWorkshop (required):

```powershell
# Clone the Microsoft365DscWorkshop repository
git clone https://github.com/raandree/Microsoft365DscWorkshop.git
cd Microsoft365DscWorkshop
# Follow the setup instructions in the Microsoft365DscWorkshop documentation
```

## Module Dependencies

DscConfig.M365 depends on:

- **Microsoft365DSC**: The underlying DSC resource module for Microsoft 365
- **Microsoft365DscWorkshop**: The deployment framework (required for the full workflow)
- Other supporting modules (specified in `RequiredModules.psd1`):
  - Datum
  - DscBuildHelpers
  - PSDesiredStateConfiguration
  - Various build tools (InvokeBuild, PSScriptAnalyzer, etc.)

## Verification

To verify that the module has been installed correctly and is ready to use:

```powershell
# Import the module to check if it loads correctly
Import-Module DscConfig.M365 -Verbose

# List available composite resources
Get-DscResource -Module DscConfig.M365
```

You should see a list of composite resources prefixed with 'c' (e.g., cAADApplication, cEXOAcceptedDomain)

## Next Steps

After installation, refer to the [Usage](Usage.md) documentation to learn how to use DscConfig.M365 to manage your Microsoft 365 resources.
