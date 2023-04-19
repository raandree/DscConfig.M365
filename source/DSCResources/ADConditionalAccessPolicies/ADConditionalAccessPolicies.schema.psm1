configuration ADConditionalAccessPolicies {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADConditionalAccessPolicy [String] #ResourceName
{
    DisplayName = [string]
    Id = [string]
    [ApplicationEnforcedRestrictionsIsEnabled = [bool]]
    [ApplicationId = [string]]
    [ApplicationSecret = [PSCredential]]
    [BuiltInControls = [string[]]]
    [CertificateThumbprint = [string]]
    [ClientAppTypes = [string[]]]
    [CloudAppSecurityIsEnabled = [bool]]
    [CloudAppSecurityType = [string]]
    [Credential = [PSCredential]]
    [CustomAuthenticationFactors = [string[]]]
    [DependsOn = [string[]]]
    [DeviceFilterMode = [string]{ exclude | include }]
    [DeviceFilterRule = [string]]
    [Ensure = [string]{ Absent | Present }]
    [ExcludeApplications = [string[]]]
    [ExcludeExternalTenantsMembers = [string[]]]
    [ExcludeExternalTenantsMembershipKind = [string]{  | all | enumerated | unknownFutureValue }]
    [ExcludeGroups = [string[]]]
    [ExcludeGuestOrExternalUserTypes = [string[]]{ b2bCollaborationGuest | b2bCollaborationMember | b2bDirectConnectUser | internalGuest | none | otherExternalUser | serviceProvider | unknownFutureValue }]
    [ExcludeLocations = [string[]]]
    [ExcludePlatforms = [string[]]]
    [ExcludeRoles = [string[]]]
    [ExcludeUsers = [string[]]]
    [GrantControlOperator = [string]{ AND | OR }]
    [IncludeApplications = [string[]]]
    [IncludeExternalTenantsMembers = [string[]]]
    [IncludeExternalTenantsMembershipKind = [string]{  | all | enumerated | unknownFutureValue }]
    [IncludeGroups = [string[]]]
    [IncludeGuestOrExternalUserTypes = [string[]]{ b2bCollaborationGuest | b2bCollaborationMember | b2bDirectConnectUser | internalGuest | none | otherExternalUser | serviceProvider | unknownFutureValue }]
    [IncludeLocations = [string[]]]
    [IncludePlatforms = [string[]]]
    [IncludeRoles = [string[]]]
    [IncludeUserActions = [string[]]]
    [IncludeUsers = [string[]]]
    [ManagedIdentity = [bool]]
    [PersistentBrowserIsEnabled = [bool]]
    [PersistentBrowserMode = [string]{  | Always | Never }]
    [PsDscRunAsCredential = [PSCredential]]
    [SignInFrequencyIsEnabled = [bool]]
    [SignInFrequencyType = [string]{  | Days | Hours }]
    [SignInFrequencyValue = [UInt32]]
    [SignInRiskLevels = [string[]]]
    [State = [string]{ disabled | enabled | enabledForReportingButNotEnforced }]
    [TenantId = [string]]
    [TermsOfUse = [string]]
    [UserRiskLevels = [string[]]]
}
#>

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName Microsoft365DSC

    foreach ($item in $Items)
    {
        if (-not $item.ContainsKey('Ensure'))
        {
            $item.Ensure = 'Present'
        }

        (Get-DscSplattedResource -ResourceName AADConditionalAccessPolicy -ExecutionName $item.DisplayName -Properties $item -NoInvoke).Invoke($item)
    }
}
