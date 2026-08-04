---
status: current
last-verified: 2026-08-04
owner: shared
source: repository evidence
---

# Product context

## Problem

Microsoft365DSC exposes hundreds of low-level DSC resources with wide parameter
surfaces and per-instance authentication parameters. Declaring them directly in
a Datum-driven configuration is repetitive and hard to maintain.

DscConfig.M365 wraps each Microsoft365DSC resource in a composite resource so a
configuration declares one block per resource type, supplies many instances
through a single `Items` array, and sets the authentication parameters once for
the whole block (`docs/Usage.md`).

## Users

- Engineers running Microsoft365DscWorkshop against one or more Microsoft 365
  tenants.
- Maintainers who bump the Microsoft365DSC version and regenerate the composite
  resources.

## Core workflows

1. Bump `Microsoft365DSC` in `RequiredModules.psd1`, run
   `./build.ps1 -ResolveDependency -Tasks build`, and let
   `Create_Dsc_Resource_Yaml_File` plus `Create_Dsc_Composite_Resources`
   regenerate every composite resource.
2. Run `./build.ps1 -Tasks test` to compile each composite resource against the
   Datum-backed sample data in `tests/Unit/DSCResources/Assets/Config`.
3. Add a resource to the supported set by adding a `c<ResourceName>.yml` asset
   under `tests/Unit/DSCResources/Assets/Config`; that folder selects which
   Microsoft365DSC resources are generated.
4. Consume the packaged module from Microsoft365DscWorkshop through its own
   `RequiredModules.psd1` (`docs/Integration.md`).

## Experience goals

- A configuration author writes `Items = @(...)` instead of one resource block
  per object.
- Authentication parameters (`TenantId`, `Credential`, `CertificateThumbprint`,
  `ApplicationId`, `ApplicationSecret`, `ManagedIdentity`, `AccessTokens`) are
  declared once per block and pushed down to each item.
- The generated composite resource keeps the original Microsoft365DSC syntax
  block in a comment so the underlying parameters stay discoverable.
