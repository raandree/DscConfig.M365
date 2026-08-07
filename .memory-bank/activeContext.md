---
status: current
last-verified: 2026-08-07
owner: active-agent
source: current task evidence
---

# Active context

## Current focus

Refresh the documentation under `docs/` and `README.md`: correct the
Microsoft365DscWorkshop integration, and add a getting started guide.

## Evidence

- The workshop moved to `dsccommunity/Microsoft365DscWorkshop`. Every doc still
  linked `raandree/Microsoft365DscWorkshop`.
- `docs/Integration.md`, `docs/Usage.md` and `docs/Examples.md` documented a
  `configurations:` / `DscResourcesToExecute:` YAML shape and a
  `source/AllNodes/Dev/M365.yml` path that do not exist in the workshop. The
  workshop keeps one YAML file per composite resource, named after the resource
  (`source/1-AllTenantsConfig/AzureAd/cAADGroup.yml`), selects composites through
  a `Configurations.yml` list per folder, and controls array merging through
  `lookup_options` in `source/Datum.yml`.
- The workshop pins `DscConfig.M365` in `RequiredModules.psd1` and registers it
  under `Sampler.DscPipeline.DscCompositeResourceModules` in `build.yaml`.
- Documentation examples used properties that Microsoft365DSC does not expose:
  `AADApplication/AvailableToOtherTenants`, `EXOAcceptedDomain/Default`, and
  nested `Conditions`/`GrantControls` on `AADConditionalAccessPolicy`. Verified
  against `Get-DscResource -Module Microsoft365DSC`.
- `docs/Installation.md` claimed Windows PowerShell 5.1 works. The
  `TestPowerShell7` task fails the build on 5.1.
- `docs/Resources.md` carried a hard-coded resource list containing resources
  that no longer exist in Microsoft365DSC `1.26.729.2`.
- `.markdownlint.json` sets `MD029: one` and `MD013: true`; the docs never
  followed it. New and rewritten content now conforms; untouched long prose
  lines were left alone.
- `HEAD` is `8c618f3` on `main`, tagged `v0.6.1`. The working tree carries an
  unrelated, uncommitted change that deletes most assets in
  `tests/Unit/DSCResources/Assets/Config`; it was left untouched.

## Next step

Decide what to do with the uncommitted deletion of the test configuration
assets in the working tree. It shrinks the generated composite resource set,
because `Create_Dsc_Resource_Yaml_File` derives that set from those files.
