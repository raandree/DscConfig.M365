configuration ADGroups {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADGroup [String] #ResourceName
{
    DisplayName = [string]
    MailNickname = [string]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]                                                                                                                                                                                                       [DependsOn = [string[]]]                                                                                                                                                                                                            [Description = [string]]                                                                                                                                                                                                            [Ensure = [string]{ Absent | Present }]                                                                                                                                                                                             [GroupTypes = [string[]]]                                                                                                                                                                                                           [Id = [string]]                                                                                                                                                                                                                     [IsAssignableToRole = [bool]]                                                                                                                                                                                                       [MailEnabled = [bool]]                                                                                                                                                                                                              [MembershipRule = [string]]
    [MembershipRuleProcessingState = [string]{ On | Paused }]
    [PsDscRunAsCredential = [PSCredential]]
    [SecurityEnabled = [bool]]
    [TenantId = [string]]
    [Visibility = [string]{ HiddenMembership | Private | Public }]
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

        $executionName = "$($item.DisplayName)_$($item.MailNickname)"
        (Get-DscSplattedResource -ResourceName AADGroup -ExecutionName $executionName -Properties $item -NoInvoke).Invoke($item)
    }
}
