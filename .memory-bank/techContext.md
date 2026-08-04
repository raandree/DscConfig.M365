---
status: current
last-verified: 2026-08-04
owner: active-agent
source: repository evidence
---

# Tech context

## Stack

- PowerShell module built with the Sampler framework: `build.yaml`, `build.ps1`,
  `Resolve-Dependency.ps1`, `RequiredModules.psd1`.
- Build engine: InvokeBuild plus ModuleBuilder; `VersionedOutputDirectory: true`
  and `BuiltModuleSubDirectory: Module`.
- Generation source: `Microsoft365DSC`, pinned in `RequiredModules.psd1`
  (currently `1.26.729.2` in the working tree; `1.25.521.1` at `HEAD`).
- `DscBuildHelpers` supplies `Get-DscResourceProperty` and
  `Get-DscSplattedResource`; the generated composite resources call the latter at
  configuration time.
- Tests: Pester 5 with `Datum` for the sample configuration data.
- Versioning: GitVersion, `mode: ContinuousDelivery`, `main` tagged `preview`.
- CI: Azure Pipelines (`azure-pipelines.yml`) with Build, Test (HQRM + Unit),
  and Deploy stages.

## Environment

- PowerShell 7+ is mandatory for the build. The `TestPowerShell7` task in
  `.build/TestPowerShellVersion.ps1` is the first step of the `build` workflow
  and errors on Windows PowerShell.
- Windows is required. The build compiles MOF files and calls `Get-DscResource`
  against Microsoft365DSC.
- Dependencies resolve into `output/RequiredModules` and are added to
  `PSModulePath` (`PSDependOptions.AddToPath`).
- Generated artifacts are untracked: `.gitignore` excludes `output`,
  `source/DSCResources`, and `source/DSCResources.yml`.

## Constraints

- `source/DscConfig.M365.psm1` is intentionally an empty stub; the module ships
  DSC composite resources, not functions.
- The set of generated resources is driven by the `*.yml` assets in
  `tests/Unit/DSCResources/Assets/Config` (176 files). When that folder is
  empty, the build falls back to every Microsoft365DSC resource.
- A resource is generated as `Scalar` when it exposes `IsSingleInstance`, and as
  `Array` otherwise (`.build/CreateDscResourceYamlFile.ps1`).
- Code coverage target is `0` in `build.yaml`; the unit tests gate on compile
  success, not coverage.
- HQRM tests exclude the Script Analyzer error-level, localization, and relative
  path length common tests.
- `Create_Dsc_Composite_Resources` deletes and recreates `source/DSCResources`
  on every run. Never hand-edit files there.

## Validation

- `./build.ps1 -Tasks build` — regenerate resources and build the module.
- `./build.ps1 -Tasks test` — Pester compile tests (VS Code task `test` runs
  `-AutoRestore -Tasks test`).
- `./build.ps1 -Tasks hqrmtest` — DscResource.Test high quality resource module
  tests.
- `./build.ps1 -UseModuleFast -ResolveDependency` — restore dependencies.
- `Invoke-ScriptAnalyzer -Path .build` — lint the build tasks.
