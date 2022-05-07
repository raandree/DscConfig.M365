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
    [ApplicationEnforcedRestrictionsIsEnabled = [bool]]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [BuiltInControls = [string[]]]
    [CertificateThumbprint = [string]]
    [ClientAppTypes = [string[]]]
    [CloudAppSecurityIsEnabled = [bool]]
    [CloudAppSecurityType = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [ExcludeApplications = [string[]]]
    [ExcludeDevices = [string[]]]
    [ExcludeGroups = [string[]]]
    [ExcludeLocations = [string[]]]
    [ExcludePlatforms = [string[]]]
    [ExcludeRoles = [string[]]]
    [ExcludeUsers = [string[]]]
    [GrantControlOperator = [string]{ AND | OR }]
    [Id = [string]]
    [IncludeApplications = [string[]]]
    [IncludeDevices = [string[]]]
    [IncludeGroups = [string[]]]
    [IncludeLocations = [string[]]]
    [IncludePlatforms = [string[]]]
    [IncludeRoles = [string[]]]
    [IncludeUserActions = [string[]]]
    [IncludeUsers = [string[]]]
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
