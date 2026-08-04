---
status: current
last-verified: 2026-08-04
owner: active-agent
source: repository evidence
---

# System patterns

## Architecture

Three-tier solution (`README.md`, `docs/Integration.md`):

1. `Microsoft365DSC` — DSC resources that call the Microsoft 365 APIs.
2. `DscConfig.M365` (this repository) — generated composite resources.
3. `Microsoft365DscWorkshop` — Datum-driven orchestration and deployment.

Code generation pipeline, in `build.yaml` order:

| Task | File | Effect |
|---|---|---|
| `TestPowerShell7` | `.build/TestPowerShellVersion.ps1` | Fails the build on Windows PowerShell |
| `Clean_Sources_Folder` | `.build/CleanSourcesFolder.ps1` | Clears generated sources |
| `Create_Dsc_Resource_Yaml_File` | `.build/CreateDscResourceYamlFile.ps1` | Writes `source/DSCResources.yml` mapping each resource to a composite name and `Scalar`/`Array` type |
| `Create_Dsc_Composite_Resources` | `.build/CreateDscCompositeResources.ps1` | Emits `source/DSCResources/<name>/<name>.schema.psm1` and `.psd1` |
| `Build_Module_ModuleBuilder` | Sampler | Builds `output/Module/DscConfig.M365` |
| `FixEncoding` | `.build/FixEncoding.ps1` | Normalizes `*.psd1` encoding for Windows PowerShell consumers |

Generated composite resource shape:

- `Array` resources take `[hashtable[]] $Items` plus the shared authentication
  parameters, iterate `$Items`, default `Ensure` to `Present`, and copy each
  unset authentication parameter from the block onto the item.
- `Scalar` resources project the underlying DSC resource parameters one-to-one,
  including `ValidateSet` values and mandatory/key flags.
- Both call
  `(Get-DscSplattedResource -ResourceName ... -NoInvoke).Invoke(...)` with an
  `ExecutionName` built from the key property values, sanitized of characters
  that are invalid in a DSC instance name.

## Decisions

### Decision 1: Use the canonical Memory Bank base

- Choice: Keep durable project context in .memory-bank.
- Rationale: Preserve evidence-backed context across sessions.

### Decision 2: Generate composite resources instead of committing them

- Choice: `source/DSCResources` and `source/DSCResources.yml` are gitignored and
  produced by the build.
- Rationale: The resource surface follows the pinned Microsoft365DSC version; a
  version bump regenerates everything deterministically.
- Consequence: Reviewing a Microsoft365DSC bump means reading the build output
  and test results, not a diff of the resource files.

### Decision 3: Derive composite GUIDs from an MD5 of the resource name

- Choice: `New-DscCompositeResourcePsd1Code` hashes
  `<CompositeResourceName><ModuleName>` with MD5 and uses the digest as the
  module GUID.
- Rationale: The GUID must stay stable across regenerations without being
  stored in the repository.
- Note: MD5 is used here as a deterministic identifier, not as a security
  control.

### Decision 4: The test config assets select the supported resource set

- Choice: `Create_Dsc_Resource_Yaml_File` filters Microsoft365DSC resources to
  the base names of the `*.yml` files in `tests/Unit/DSCResources/Assets/Config`
  (with the leading `c` stripped).
- Rationale: Every generated resource is covered by a compile test.
- Consequence: Supporting a new resource means adding its config asset first.
