configuration ADGroupNamingPolicies {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADGroupsNamingPolicy [String] #ResourceName
{
    IsSingleInstance = [string]{ Yes }
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [CustomBlockedWordsList = [string[]]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [PrefixSuffixNamingRequirement = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [TenantId = [string]]
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

        (Get-DscSplattedResource -ResourceName AADGroupsNamingPolicy -ExecutionName AADGroupsNamingPolicy -Properties $item -NoInvoke).Invoke($item)
    }
}
