# DscConfig.M365

DSC Composite Resources for Microsoft 365 management with PowerShell Desired State Configuration (DSC).

## Overview

DscConfig.M365 provides an abstraction layer between the [Microsoft365DSC](https://github.com/microsoft/Microsoft365DSC) resources and the deployment framework in [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop). It creates DSC composite resources from the Microsoft365DSC resources to simplify configuration management and deployment of Microsoft 365 resources.

This module is part of a complete solution that requires:

- [Microsoft365DSC](https://github.com/microsoft/Microsoft365DSC) - The underlying DSC resource module for Microsoft 365
- [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop) - The deployment framework for managing configurations

> **Important:** DscConfig.M365 is not meant to be installed separately. It is automatically included as a dependency by Microsoft365DscWorkshop through its PSDepend configuration in the RequiredModules.psd1 file.

## Purpose

This project serves as the middle layer in a three-tier architecture for Microsoft 365 configuration management:

1. **Microsoft365DSC** - The foundation layer providing the DSC resources that interact with Microsoft 365 APIs
1. **DscConfig.M365** (this project) - The abstraction layer creating composite resources with simplified interfaces
1. **Microsoft365DscWorkshop** - The orchestration layer that consumes these composite resources for deployment

By separating these concerns, the solution provides a more maintainable and scalable approach to Microsoft 365 configuration management.

## How It Works

The module dynamically generates DSC composite resources (prefixed with 'c') for each Microsoft365DSC resource. It creates two types of composite resources based on the resource structure:

- **Scalar resources** - For singleton resources (with `IsSingleInstance` property)
- **Array resources** - For resources that can have multiple instances

An array composite resource takes all instances through a single `Items` array
and accepts the Microsoft 365 connection parameters once for the whole block
instead of once per instance.

## Getting Started

> **Important:** DscConfig.M365 is designed to work with [Microsoft365DscWorkshop](https://github.com/dsccommunity/Microsoft365DscWorkshop) and is not intended for standalone use.

Start with the [Getting Started](docs/GettingStarted.md) guide. It covers both
consuming the composite resources through Microsoft365DscWorkshop and building
this module from source.

The remaining documentation:

- [Installation](docs/Installation.md)
- [Usage](docs/Usage.md)
- [Examples](docs/Examples.md)
- [Integration with Microsoft365DscWorkshop](docs/Integration.md)
- [Available resources](docs/Resources.md)

## Resources

The module creates composite resources for the Microsoft365DSC resources that are
covered by the sample configuration data in
`tests/Unit/DSCResources/Assets/Config`. They are generated during the build
process and are not stored in the repository.

For how the set is determined and how to list it, see [Available Resources](docs/Resources.md).

## Contributing

Please read our [Contributing Guide](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the [MIT License](LICENSE).
