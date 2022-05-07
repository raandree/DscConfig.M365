configuration ADTokenLifetimePolicies {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

    <#
AADTokenLifetimePolicy [String] #ResourceName
{
    DisplayName = [string]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [Definition = [string[]]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Id = [string]]
    [IsOrganizationDefault = [bool]]
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

        (Get-DscSplattedResource -ResourceName AADTokenLifetimePolicy -ExecutionName $item.DisplayName -Properties $item -NoInvoke).Invoke($item)
    }
}
