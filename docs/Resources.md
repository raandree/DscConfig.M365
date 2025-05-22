# Available Resources

This document lists the composite DSC resources available in the DscConfig.M365 module. All resources are dynamically generated during the module build process based on the resources available in Microsoft365DSC.

## Resource Naming Convention

All composite resources in DscConfig.M365 follow a naming convention:

- Prefixed with 'c' (for composite)
- Followed by the original Microsoft365DSC resource name
- Example: `AADApplication` in Microsoft365DSC becomes `cAADApplication` in DscConfig.M365

## Resource Categories

The resources are organized into the following categories based on Microsoft 365 workloads:

### Azure Active Directory (AAD)

- cAADAdministrativeUnit
- cAADApplication
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
- cAADAuthorizationPolicy
- cAADConditionalAccessPolicy
- cAADCrossTenantAccessPolicy
- cAADExternalIdentityPolicy
- cAADGroup
- cAADGroupLifecyclePolicy
- cAADGroupsNamingPolicy
- cAADGroupsSettings
- cAADNamedLocationPolicy
- cAADRoleDefinition
- cAADRoleSetting
- cAADSecurityDefaults
- cAADServicePrincipal
- cAADTenantDetails
- cAADTokenLifetimePolicy

### Exchange Online (EXO)

- cEXOAcceptedDomain
- cEXODistributionGroup
- cEXOInboundConnector
- cEXOManagementRole
- cEXOManagementRoleAssignment
- cEXOManagementRoleEntry
- cEXOOutboundConnector
- cEXORemoteDomain
- cEXOTransportConfig
- cEXOTransportRule

### Intune

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
- cIntuneDeviceConfigurationPolicyWindows10
- cIntunePolicySets
- cIntuneRoleAssignment
- cIntuneSettingCatalogASRRulesPolicyWindows10
- cIntuneSettingCatalogCustomPolicyWindows10

### SharePoint Online (SPO)

- cSPOAccessControlSettings
- cSPOSharingSettings
- cSPOTenantSettings

### Security & Compliance (SC)

- cSCAutoSensitivityLabelPolicy
- cSCAutoSensitivityLabelRule
- cSCAuditConfigurationPolicy
- cSCComplianceTag
- cSCDeviceConditionalAccessPolicy
- cSCDeviceConfigurationPolicy
- cSCDLPCompliancePolicy
- cSCDLPComplianceRule
- cSCFilePlanPropertyAuthority
- cSCFilePlanPropertyCategory
- cSCFilePlanPropertyCitation
- cSCFilePlanPropertyDepartment
- cSCFilePlanPropertyReferenceId
- cSCFilePlanPropertySubCategory
- cSCProtectionAlert
- cSCRetentionCompliancePolicy
- cSCRetentionComplianceRule
- cSCRetentionEventType
- cSCRoleGroup
- cSCRoleGroupMember
- cSCSecurityFilter
- cSCSupervisoryReviewPolicy
- cSCSupervisoryReviewRule

### Office 365 (O365)

- cO365OrgSettings

### Teams

- Various Teams-related resources

## Resource Types

The resources are categorized into two types:

1. **Scalar Resources**: Resources that have a single instance per tenant, identified by the `IsSingleInstance` property.
2. **Array Resources**: Resources that can have multiple instances and are configured using an array of items.

## Resource Generation

These resources are dynamically generated during the build process from Microsoft365DSC resources. The generation process:

1. Identifies all Microsoft365DSC resources
2. Determines if each resource is a scalar or array type
3. Creates corresponding composite resources with appropriate parameters
4. Adds authentication parameters (Credential, CertificateThumbprint, ApplicationId, etc.)

The generated resources are not stored in the repository but are created during module build.

## Viewing Available Resources

To see the list of composite resources available in your current installation:

```powershell
Get-DscResource -Module DscConfig.M365
```

## Resource Documentation

For detailed documentation about each resource's parameters and usage, refer to the [Microsoft365DSC documentation](https://microsoft365dsc.com/docs/resources/), as the composite resources mirror the underlying Microsoft365DSC resources while simplifying their usage.
