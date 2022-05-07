configuration ADGroupLifecyclePolicies {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADGroupLifecyclePolicy [String] #ResourceName
{
    AlternateNotificationEmails = [string[]]
    GroupLifetimeInDays = [UInt32]
    IsSingleInstance = [string]{ Yes }
    ManagedGroupTypes = [string]{ All | None | Selected }
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
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

        (Get-DscSplattedResource -ResourceName AADGroupLifecyclePolicy -ExecutionName AADGroupLifecyclePolicy -Properties $item -NoInvoke).Invoke($item)
    }
}
