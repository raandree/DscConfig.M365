# Changelog for DscConfig.Demo

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
