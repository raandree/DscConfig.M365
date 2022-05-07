configuration ADServicePrincipals {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADServicePrincipal [String] #ResourceName
{
    AppId = [string]
    [AccountEnabled = [bool]]
    [AlternativeNames = [string[]]]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [AppRoleAssignmentRequired = [bool]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [DisplayName = [string]]
    [Ensure = [string]{ Absent | Present }]
    [ErrorUrl = [string]]
    [Homepage = [string]]
    [LogoutUrl = [string]]
    [ObjectID = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [PublisherName = [string]]
    [ReplyUrls = [string[]]]
    [SamlMetadataUrl = [string]]
    [ServicePrincipalNames = [string[]]]
    [ServicePrincipalType = [string]]
    [Tags = [string[]]]
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

        (Get-DscSplattedResource -ResourceName AADServicePrincipal -ExecutionName $item.AppId -Properties $item -NoInvoke).Invoke($item)
    }
}
