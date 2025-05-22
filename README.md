# DscConfig.M365

DSC Composite Resources for Microsoft 365 management with PowerShell Desired State Configuration (DSC).

## Overview

DscConfig.M365 provides an abstraction layer between the [Microsoft365DSC](https://github.com/microsoft/Microsoft365DSC) resources and the deployment framework in [Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop). It creates DSC composite resources from the Microsoft365DSC resources to simplify configuration management and deployment of Microsoft 365 resources.

This module is part of a complete solution that requires:
- [Microsoft365DSC](https://github.com/microsoft/Microsoft365DSC) - The underlying DSC resource module for Microsoft 365
- [Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop) - The deployment framework for managing configurations

## Purpose

This project serves as the middle layer in a three-tier architecture for Microsoft 365 configuration management:

1. **Microsoft365DSC** - The foundation layer providing the DSC resources that interact with Microsoft 365 APIs
2. **DscConfig.M365** (this project) - The abstraction layer creating composite resources with simplified interfaces
3. **Microsoft365DscWorkshop** - The orchestration layer that consumes these composite resources for deployment

By separating these concerns, the solution provides a more maintainable and scalable approach to Microsoft 365 configuration management.

## How It Works

The module dynamically generates DSC composite resources (prefixed with 'c') for each Microsoft365DSC resource. It creates two types of composite resources based on the resource structure:

- **Scalar resources** - For singleton resources (with `IsSingleInstance` property)
- **Array resources** - For resources that can have multiple instances

## Getting Started

> **Important:** DscConfig.M365 is designed to work with [Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop) and is not intended for standalone use.

See the [Installation](docs/Installation.md), [Usage](docs/Usage.md), and [Integration with Microsoft365DscWorkshop](docs/Integration.md) documentation for details on getting started.

## Resources

The module creates composite resources for all Microsoft365DSC resources. These resources are dynamically generated during the build process and are not stored in the repository.

For a full list of available resources, see [Available Resources](docs/Resources.md).

## Contributing

Please read our [Contributing Guide](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the [MIT License](LICENSE).
