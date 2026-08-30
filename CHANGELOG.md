# Changelog for DscConfig.M365

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- New `docs/GettingStarted.md` guide covering both supported paths: consuming the
  composite resources through Microsoft365DscWorkshop and building this module
  from source, including prerequisites, a first configuration and troubleshooting.
- Test configuration data for additional Microsoft365DSC resources:
  `AADB2BManagementPolicy`, `AADDeviceRegistrationPolicy`, `EXOMailContact`,
  `EXOSharedMailbox`, `IntuneWindowsAutopilotDeploymentProfileAzureADJoined`,
  `IntuneWindowsHelloForBusinessGlobalPolicy`, and the Android Enterprise Wi-Fi
  configuration policies (`AndroidEnterpriseDeviceOwner`,
  `AndroidEnterpriseWorkProfile`, `AndroidForWork`, `AndroidOpenSourceProject`).
- Corrected Syntax Errors for Example configuration data for the contrbuted resources

### Removed

- Obsolete `cIntuneWifiConfigurationPolicyAndroidDeviceAdministrator` test
  configuration data.

### Changed

- Corrected the Microsoft365DscWorkshop repository URL throughout the
  documentation. The project moved from `raandree/Microsoft365DscWorkshop` to
  `dsccommunity/Microsoft365DscWorkshop`.
- Rewrote the Microsoft365DscWorkshop integration documentation to match the
  actual configuration data layout: one YAML file per composite resource under
  the Datum hierarchy in `source/`, `Configurations.yml` to select the composite
  resources to enact, and the `lookup_options` needed to merge `Items` across
  layers. The previous `configurations/DscResourcesToExecute` example did not
  exist in Microsoft365DscWorkshop.
- Corrected the prerequisites in `docs/Installation.md`. The build requires
  Windows and PowerShell 7 or later; Windows PowerShell 5.1 fails in the
  `TestPowerShell7` task.
- Replaced the hard-coded resource list in `docs/Resources.md` with a description
  of how the generated set is determined by the assets in
  `tests/Unit/DSCResources/Assets/Config`, plus commands to list the resources of
  an installation. The previous list referenced resources that no longer exist in
  Microsoft365DSC.
- Fixed documentation examples that used properties the Microsoft365DSC resources
  do not expose: `AvailableToOtherTenants` on `AADApplication`, `Default` on
  `EXOAcceptedDomain`, and the nested `Conditions`/`GrantControls` objects on
  `AADConditionalAccessPolicy`.
- Documented the full set of connection parameters on array composite resources,
  including `ApplicationSecret` and `AccessTokens`, and noted that the push-down
  to `Items` is only generated for resources that expose `Ensure`.
- Update Microsoft365DSC to version 1.26.729.2 and set DscBuildHelpers and PSDesiredStateConfiguration to latest.
- Update Microsoft365DSC to version 1.26.819.1.
- Pinned `Pester` to `5.9.1` in `RequiredModules.psd1`; the `test` build workflow
  now runs `build` first.
- The `Create_Dsc_Composite_Resources` and `Create_Dsc_Resource_Yaml_File` build
  tasks now resolve Microsoft365DSC by the exact version pinned in
  `RequiredModules.psd1` and temporarily strip the `Program Files` module paths
  when calling `Get-DscResource`, avoiding duplicate CIM class definitions when
  the same version is also present in a system module path.
- `DscResources.Tests.ps1` keeps Pester discovery stable when `Get-DscResource`
  returns nothing for the built module, skips the composite-resource checks when
  the `DSCResources` folder is absent, and validates the generated set against
  the composite resource names declared in `source/DSCResources.yml`.
- Updated the test configuration data in `tests/Unit/DSCResources/Assets/Config` to the schemas
  shipped with Microsoft365DSC 1.26.729.2:
  - Removed the properties `AvailableToOtherTenants` (`AADApplication`, replaced by `SignInAudience`),
    `SupportsScopeTags` (Intune device configuration policies), `UserVoiceForFeedbackEnabled`
    (`SPOTenantSettings`), `EnableShiftPresence` (`TeamsShiftsPolicy`), `OptimizeDeviceDialing`
    (`TeamsTenantDialPlan`) and `AllowPublicUsers` (`TeamsFederationConfiguration`).
  - Renamed `ElegibilityAssignmentReq*` to `EligibilityAssignmentReq*` (`AADRoleSetting`).
  - Moved `RequireAcceptingAccountMatchInvitedAccount` from `SPOSharingSettings` to `SPOTenantSettings`.
  - Replaced `LocalUserGroupCollection` with `AccessGroup`
    (`IntuneAccountProtectionLocalUserGroupMembershipPolicy`).
  - `MaximumRecordingLength` (`TeamsOnlineVoicemailPolicy`) is now a number of seconds instead of a timespan.
  - `ContentContainsSensitiveInformation` (`SCDLPComplianceRule`) is now an array.
  - Converted `AADAuthenticationMethodPolicy` and the `Teams*Configuration` resources from array to
    single-instance configuration data, as they now expose `IsSingleInstance`.

### Fixed

- The composite resource code generator no longer emits embedded CIM instance class names as parameter
  types. Properties like `AADAuthenticationMethodPolicy/RegistrationEnforcement` are now typed as
  `hashtable` (or `hashtable[]`), so the generated composite resource can be loaded and discovered again.

## [0.6.0] - 2025-05-22

### Added

- The code generator will add standard connection parameters to to each array composite resource:
  - TenantId
  - ManagedIdentity
  - Credential
  - CertificateThumbprint
  - ApplicationSecret
  - ApplicationId
  - AccessTokens
- Added test `'<DscResourceName>' MOF file should contain Azure connection data`.
- Added more documentation.

### Changed

- Updated the `Microsoft365DSC` module to version `1.25.205.1` in `RequiredModules.psd1`.
- Updated the `DscBuildHelpers` module to version `0.3.0-preview0003` in `RequiredModules.psd1`.
- `Get-DscResourceProperty` is not a public function hence in needs to be called in the module context.

### Removed

- `DscBuildHelpers` module and in gitignore
- `ProtectedData` module and in gitignore

## [0.5.0] - 2024-10-31

### Added

- Teams Resources. This was initially created from Microsoft365DSC 1.24.515.2.
- Added test data for:
  - cAADExternalIdentityPolicy
  - cAADCrossTenantAccessPolicy
  - cIntuneAccountProtectionLocalAdministratorPasswordSolutionPolicy
  - cIntuneAccountProtectionLocalUserGroupMembershipPolicy
  - cIntuneAccountProtectionPolicy
  - cIntuneAntivirusPolicyWindows10SettingCatalog
  - cIntuneAppConfigurationDevicePolicy
  - cIntuneAppConfigurationPolicy
  - cIntuneApplicationControlPolicyWindows10
  - cIntuneAppProtectionPolicyAndroid
  - cIntuneAppProtectionPolicyiOS
  - cIntuneDeviceAndAppManagementAssignmentFilter
  - cIntuneDeviceCategory
  - cIntuneDeviceCleanupRule
  - cIntuneDeviceCompliancePolicyAndroid
  - cIntuneDeviceCompliancePolicyAndroidDeviceOwner
  - cIntuneDeviceCompliancePolicyAndroidWorkProfile
  - cIntuneDeviceCompliancePolicyiOs
  - cIntuneDeviceCompliancePolicyMacOS
  - cIntuneDeviceCompliancePolicyWindows10
  - cIntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10
  - cIntuneDeviceConfigurationCustomPolicyWindows10
  - cIntuneDeviceConfigurationDefenderForEndpointOnboardingPolicyWindows10
  - cIntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10
  - cIntuneDeviceConfigurationDomainJoinPolicyWindows10
  - cIntuneDeviceConfigurationEditionUpgradePolicyWindows10
  - cIntuneDeviceConfigurationIdentityProtectionPolicyWindows10
  - cIntuneDeviceConfigurationImportedPfxCertificatePolicyWindows10
  - cIntuneDeviceConfigurationPlatformScriptWindows
  - cIntuneDeviceConfigurationPolicyAndroidDeviceAdministrator
  - cIntuneDeviceConfigurationPolicyAndroidDeviceOwner
  - cIntuneDeviceConfigurationPolicyAndroidWorkProfile
  - cIntuneDeviceConfigurationPolicyIOS
  - cIntuneDeviceConfigurationPolicyMacOS
  - cIntuneDeviceConfigurationPolicyWindows10
  - cIntuneDeviceConfigurationSecureAssessmentPolicyWindows10
  - cIntuneDeviceConfigurationSharedMultiDevicePolicyWindows10
  - cIntuneDeviceConfigurationWiredNetworkPolicyWindows10
  - cIntuneDeviceEnrollmentLimitRestriction
  - cIntuneDeviceEnrollmentPlatformRestriction
  - cIntuneDeviceEnrollmentStatusPageWindows10
  - cIntuneDiskEncryptionMacOS
  - cIntuneDiskEncryptionWindows10
  - cIntuneEndpointDetectionAndResponsePolicyWindows10
  - cIntuneExploitProtectionPolicyWindows10SettingCatalog
  - cIntunePolicySets
  - cIntuneRoleAssignment
  - cIntuneSettingCatalogASRRulesPolicyWindows10
  - cIntuneSettingCatalogCustomPolicyWindows10
  - cIntuneWifiConfigurationPolicyAndroidDeviceAdministrator
  - cIntuneWifiConfigurationPolicyMacOS
  - cIntuneWifiConfigurationPolicyWindows10
  - cIntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled
  - cIntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10
  - cIntuneWindowsUpdateForBusinessRingUpdateProfileWindows10
  - cSCRetentionCompliancePolicy
  - cSCRetentionComplianceRule
  - cSCRoleGroup
  - cSCAutoSensitivityLabelPolicy
  - cSCRoleGroupMember
  - cSCDeviceConditionalAccessPolicy
  - cSCDeviceConfigurationPolicy
  - cSCProtectionAlert
  - cSCSecurityFilter
  - cSCAuditConfigurationPolicy
  - cSCAutoSensitivityLabelRule
  - cSCFilePlanPropertyAuthority
  - cSCFilePlanPropertyCategory
  - cSCFilePlanPropertyCitation
  - cSCFilePlanPropertyDepartment
  - cSCFilePlanPropertyReferenceId
  - cSCFilePlanPropertySubCategory
  - cSCRetentionEventType
  - cSCSupervisoryReviewPolicy
  - cSCSupervisoryReviewRule

### Changed

- Updated 'Resolve-Dependency.ps1' to latest version of Sampler.
- Updated 'Microsoft365DSC' to 1.24.1016.1.

## [0.4.0] - 2024-09-11

### Changed

- Set 'Microsoft365DSC' version to 1.24.904.1.
- Removed dependency to 'xDscResourceDesigner' in 'DscBuildHelpers'.
- Build uses 'UseModuleFast' now in Azure pipelines.
- Update GitVersion.Tool installation to version 5.* in Azure pipelines.

### Added

- Added test data for:
  - cEXOInboundConnector
  - cEXOOutboundConnector
  - cEXOManagementRole
  - cEXOManagementRoleAssignment
  - cEXOManagementRoleEntry

### Fixes

- Fixed a bug in the code generator when there is no ensure property for a resource.

## [0.3.2] - 2024-06-04

### Added

- Added test data for:
  - cSCComplianceTag
  - cSCDLPCompliancePolicy
  - cSCDLPComplianceRule

### Changed

- Updated build scripts to latest version of Sampler with support of ModuleFast.

### Fixes

- Tests
  - Explicitly add resource to test script to prevent checking for all resources every test.

## [0.3.1] - 2024-05-24

### Changed

- Excluding folder 'source/DSCResources' from git.
- Updated these modules to latest version:
  - ProtectedData
  - DscBuildHelpers
- Updated to latest Sampler build scripts.

### Added

- Added test data for:
  - cEXOTransportRule
  - cEXODistributionGroup
  - cAADAdministrativeUnit
  - cAADAuthenticationMethodPolicy
  - cAADAuthenticationMethodPolicyAuthenticator
  - cAADAuthenticationMethodPolicyEmail
  - cAADAuthenticationMethodPolicyFido2
  - cAADAuthenticationMethodPolicySms
  - cAADAuthenticationMethodPolicySoftware
  - cAADAuthenticationMethodPolicyTemporary
  - cAADAuthenticationMethodPolicyVoice
  - cAADAuthenticationMethodPolicyX509
  - cAADAuthenticationStrengthPolicy
  - cO365OrgSettings
  - cSPOAccessControlSettings
  - cSPOSharingSettings
  - cSPOTenantSettings

## [0.3.0] - 2024-02-25

### Changed

- Build requires PowerShell 7 now.
- Fixed build issues by adding pre-release of 'DscBuildHelpers'.

## [0.2.3] - 2023-09-05

### Added

- Added check to prevent the build running in PS7+.
- Removed hard-coded resources.
- Updated M365DSC to 1.23.830.1.
- Added test data for 'cEXOAcceptedDomain'.
- Added test data for 'cEXORemoteDomain'

## [0.2.2] - 2023-04-19

### Changed

- Updated M365DSC to 1.23.412.1

### Added

- Added 'EXTransportConfig' config with test data.

## [0.2.1] - 2023-01-15

### Changed

- Updated pipeline to latest version of Sampler.

## [0.2.0] - 2022-10-11

### Added

- Initial Release.
- Added configuration `ADAuthorizationPolicies`.
- Added configuration `ADRoleSettings`.
- Added configuration `ADSecurityDefaults`.

### Fixed

- Fixed resource `ADGroupSettings` according to `IsSingleInstance`.
