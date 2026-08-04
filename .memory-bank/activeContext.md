---
status: current
last-verified: 2026-08-04
owner: active-agent
source: current task evidence
---

# Active context

## Current focus

Bump `Microsoft365DSC` from `1.25.521.1` to `1.26.729.2` on branch
`feature/update2608` and get the build green again. Done, not yet committed.

## Evidence

- `./build.ps1 -Tasks build,test` exits `0`: 509 tests passed, 0 failed,
  169 MOF files from 169 composite resource folders and 169 discoverable
  composite resources.
- Root cause 1: `ConvertTo-PowerShellType` in
  `.build/CreateDscCompositeResources.ps1` fell through to `return $TypeName`
  for embedded CIM instance properties, emitting unresolvable parameter types
  such as `[MSFT_MicrosoftGraphregistrationEnforcement]`. The generated
  `cAADAuthenticationMethodPolicy` composite could not be loaded, so
  `Get-DscResource` returned 168 resources for 169 folders. Fixed by mapping
  `MSFT_*` to `hashtable` / `hashtable[]`.
- Root cause 2: 21 test config assets in
  `tests/Unit/DSCResources/Assets/Config` no longer matched the upstream
  schemas (removed and renamed properties, `Array` to `Scalar` flips,
  `ContentContainsSensitiveInformation` and `AccessGroup` restructured,
  `MaximumRecordingLength` retyped to `SInt32`).
- `HEAD` is `84dcfd5` on `feature/update2608`; all fixes are uncommitted.

## Next step

Commit the working-tree changes when the user asks. Optionally remove the seven
dead assets whose resources no longer exist in Microsoft365DSC
(`cIntuneAccountProtectionPolicy`, `cIntuneDeviceCleanupRule`,
`cIntuneDeviceCompliancePolicyAndroid`,
`cIntuneDeviceConfigurationDefenderForEndpointOnboardingPolicyWindows10`,
`cIntuneDeviceConfigurationEditionUpgradePolicyWindows10`,
`cIntuneDeviceConfigurationPolicyAndroidDeviceAdministrator`,
`cIntuneWifiConfigurationPolicyAndroidDeviceAdministrator`); they are silently
filtered out by `Create_Dsc_Resource_Yaml_File` and do not break the build.
