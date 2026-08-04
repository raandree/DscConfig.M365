---
status: current
last-verified: 2026-08-04
owner: shared
source: repository evidence
---

# Project brief

## Purpose

DscConfig.M365 generates DSC composite resources (each prefixed with `c`) from
the DSC resources shipped by
[Microsoft365DSC](https://github.com/microsoft/Microsoft365DSC). It is the
abstraction layer between Microsoft365DSC and the deployment framework
[Microsoft365DscWorkshop](https://github.com/raandree/Microsoft365DscWorkshop),
as stated in `README.md` and `docs/Integration.md`.

The composite resources are not stored in the repository. They are generated at
build time into `source/DSCResources`, which `.gitignore` excludes together with
`source/DSCResources.yml` and `output`.

## Scope

- In scope: the Invoke-Build tasks under `.build/` that emit the composite
  resource `*.schema.psm1` and `*.psd1` files, the Sampler build and packaging
  pipeline, the pinned `Microsoft365DSC` version in `RequiredModules.psd1`, and
  the compile tests plus per-resource configuration assets under
  `tests/Unit/DSCResources`.
- In scope: documentation under `docs/` and the changelog.
- Out of scope: the Microsoft365DSC resources themselves, tenant configuration
  data, deployment orchestration, and credential handling. Those belong to
  Microsoft365DSC and Microsoft365DscWorkshop.
- Out of scope: standalone installation. `README.md` states the module is
  consumed as a Microsoft365DscWorkshop dependency, not installed separately.

## Stakeholders

- Maintainer: `raandree` (repository owner of the `main` remote).
- Publishing identity: DSC Community; `source/DscConfig.M365.psd1` sets Author
  and CompanyName to `DSC Community` and the ProjectUri to the
  `dsccommunity/DscConfig.M365` repository.
- Consumers: Microsoft365DscWorkshop users configuring Microsoft 365 tenants.

## Acceptance criteria

1. `./build.ps1 -Tasks build` regenerates `source/DSCResources.yml` and one
   composite resource folder per selected Microsoft365DSC resource, then builds
   the versioned module under `output/Module/DscConfig.M365`.
2. `./build.ps1 -Tasks test` compiles every generated composite resource to a
   MOF file under `output/MOF` and asserts each MOF carries Azure connection
   data (`tests/Unit/DSCResources/DscResources.Tests.ps1`).
3. A Microsoft365DSC version bump is reflected in `RequiredModules.psd1` and in
   `CHANGELOG.md` under `[Unreleased]`.
