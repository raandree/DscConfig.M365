configuration ADNamedLocationPolicies {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADNamedLocationPolicy [String] #ResourceName
{
    DisplayName = [string]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [CountriesAndRegions = [string[]]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [Id = [string]]
    [IncludeUnknownCountriesAndRegions = [bool]]
    [IpRanges = [string[]]]
    [IsTrusted = [bool]]
    [OdataType = [string]{ #microsoft.graph.countryNamedLocation | #microsoft.graph.ipNamedLocation }]
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

        (Get-DscSplattedResource -ResourceName AADNamedLocationPolicy -ExecutionName $item.DisplayName -Properties $item -NoInvoke).Invoke($item)
    }
}
