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

To implement a complete solution, you typically just need to set up Microsoft365DscWorkshop, which automatically includes DscConfig.M365:

1. Clone and set up Microsoft365DscWorkshop:

```powershell
# Clone the Microsoft365DscWorkshop repository
git clone https://github.com/raandree/Microsoft365DscWorkshop.git
cd Microsoft365DscWorkshop

# Run the bootstrap script which will download all dependencies including DscConfig.M365
./Build.ps1 -ResolveDependency
```

Microsoft365DscWorkshop's `RequiredModules.psd1` file already includes DscConfig.M365 as a dependency, so it will be automatically downloaded and made available to your project. You don't need to install or reference DscConfig.M365 separately.

## Workflow Overview

The typical workflow when using these projects together:

1. **Define Resources**: Use DscConfig.M365 composite resources to define Microsoft 365 configurations
2. **Organize Configuration Data**: Structure your configuration data in Microsoft365DscWorkshop
3. **Build & Test**: Use Microsoft365DscWorkshop build pipeline to compile and test configurations
4. **Deploy**: Deploy configurations to your Microsoft 365 tenants using Microsoft365DscWorkshop

## Example Integration

Here's a simplified example of how Microsoft365DscWorkshop consumes DscConfig.M365 resources using YAML-based configuration:

```yaml
# In Microsoft365DscWorkshop's YAML configuration files
# For example, in source/AllNodes/Dev/M365.yml
configurations:
  - M365:  # This is the name of the configuration document to generate
      DscResourcesToExecute:
        cAADGroup:
          TenantId: contoso.onmicrosoft.com
          Credential: "[ENC=PE9ianMgVmVyc2lvbj0iMS4xLjAu...encoded credential...==]"
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
        
        cEXOTransportRule:
          TenantId: contoso.onmicrosoft.com
          Credential: "[ENC=PE9ianMgVmVyc2lvbj0iMS4xLjAu...encoded credential...==]"
          Items:
            - Name: "External Email Warning"
              FromScope: "NotInOrganization"
              SentToScope: "InOrganization"
              ApplyHtmlDisclaimerLocation: "Prepend"
              ApplyHtmlDisclaimerText: "<p>[External Email Warning]</p>"
              Ensure: "Present"
```

## Additional Resources

- [Microsoft365DSC GitHub Repository](https://github.com/microsoft/Microsoft365DSC)
- [Microsoft365DscWorkshop GitHub Repository](https://github.com/raandree/Microsoft365DscWorkshop)
- [PowerShell DSC Documentation](https://docs.microsoft.com/en-us/powershell/dsc/overview)
