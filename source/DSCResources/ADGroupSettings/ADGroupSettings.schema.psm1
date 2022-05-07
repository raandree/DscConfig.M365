configuration ADGroupSettings {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADGroupsSettings [String] #ResourceName
{
    IsSingleInstance = [string]{ Yes }
    [AllowGuestsToAccessGroups = [bool]]
    [AllowGuestsToBeGroupOwner = [bool]]
    [AllowToAddGuests = [bool]]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [EnableGroupCreation = [bool]]
    [Ensure = [string]{ Absent | Present }]
    [GroupCreationAllowedGroupName = [string]]
    [GuestUsageGuidelinesUrl = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [TenantId = [string]]
    [UsageGuidelinesUrl = [string]]
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

        (Get-DscSplattedResource -ResourceName AADGroupsSettings -ExecutionName AADGroupsSettingsInstance -Properties $item -NoInvoke).Invoke($item)
    }
}
