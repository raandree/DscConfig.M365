# Integration with Microsoft365DscWorkshop

This document explains how DscConfig.M365 integrates with Microsoft365DscWorkshop and why both projects are essential for a complete Microsoft 365 configuration management solution.

## The Three-Tier Architecture

The complete solution for Microsoft 365 configuration management consists of three layers:

1. **Microsoft365DSC** - The foundation layer providing the DSC resources that interact with Microsoft 365 APIs
2. **DscConfig.M365** (this project) - The abstraction layer creating composite resources with simplified interfaces
3. **Microsoft365DscWorkshop** - The orchestration layer that consumes these composite resources for deployment

Each layer serves a specific purpose, and they work together to provide a comprehensive configuration management solution.

## Why Microsoft365DscWorkshop Is Required

DscConfig.M365 is designed to work with Microsoft365DscWorkshop for several important reasons:

1. **Deployment Framework**: Microsoft365DscWorkshop provides the deployment infrastructure and orchestration mechanisms needed to apply configurations effectively.

2. **Environment Management**: Microsoft365DscWorkshop handles environment-specific configurations and separates them from the resource definitions.

3. **Configuration Data Management**: Microsoft365DscWorkshop implements the Datum pattern for managing configuration data hierarchies.

4. **CI/CD Integration**: Microsoft365DscWorkshop provides the scaffolding for continuous integration and deployment of Microsoft 365 configurations.

## Setting Up the Complete Solution

To implement a complete solution, you need to set up both projects:

1. Install DscConfig.M365 according to the [Installation](Installation.md) instructions.

2. Set up Microsoft365DscWorkshop:

```powershell
# Clone the Microsoft365DscWorkshop repository
git clone https://github.com/raandree/Microsoft365DscWorkshop.git
cd Microsoft365DscWorkshop

# Follow the setup instructions in the Microsoft365DscWorkshop README
```

3. Configure Microsoft365DscWorkshop to use DscConfig.M365:

```powershell
# In your Microsoft365DscWorkshop's RequiredModules.psd1, ensure DscConfig.M365 is listed
@{
    DscConfig.M365 = 'latest'
    # Other required modules
}
```

## Workflow Overview

The typical workflow when using these projects together:

1. **Define Resources**: Use DscConfig.M365 composite resources to define Microsoft 365 configurations
2. **Organize Configuration Data**: Structure your configuration data in Microsoft365DscWorkshop
3. **Build & Test**: Use Microsoft365DscWorkshop build pipeline to compile and test configurations
4. **Deploy**: Deploy configurations to your Microsoft 365 tenants using Microsoft365DscWorkshop

## Example Integration

Here's a simplified example of how Microsoft365DscWorkshop consumes DscConfig.M365 resources:

```powershell
# In Microsoft365DscWorkshop configuration
configuration M365Configuration {
    Import-DscResource -ModuleName DscConfig.M365

    node $AllNodes.NodeName {
        # Use composite resources from DscConfig.M365
        cAADGroup Groups {
            Items = $ConfigurationData.Groups
            TenantId = $ConfigurationData.TenantId
            Credential = $Credential
        }

        cEXOTransportRule TransportRules {
            Items = $ConfigurationData.TransportRules
            TenantId = $ConfigurationData.TenantId
            Credential = $Credential
        }
    }
}
```

## Additional Resources

- [Microsoft365DSC GitHub Repository](https://github.com/microsoft/Microsoft365DSC)
- [Microsoft365DscWorkshop GitHub Repository](https://github.com/raandree/Microsoft365DscWorkshop)
- [PowerShell DSC Documentation](https://docs.microsoft.com/en-us/powershell/dsc/overview)
