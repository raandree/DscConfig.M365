configuration ADApplications {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADApplication [String] #ResourceName
{
    DisplayName = [string]
    [AppId = [string]]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [AvailableToOtherTenants = [bool]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [GroupMembershipClaims = [string]]
    [Homepage = [string]]
    [IdentifierUris = [string[]]]
    [KnownClientApplications = [string[]]]
    [LogoutURL = [string]]
    [Oauth2RequirePostResponse = [bool]]
    [ObjectId = [string]]
    [Permissions = [MSFT_AADApplicationPermission[]]]
    [PsDscRunAsCredential = [PSCredential]]
    [PublicClient = [bool]]
    [ReplyURLs = [string[]]]
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

        (Get-DscSplattedResource -ResourceName AADApplication -ExecutionName $item.DisplayName -Properties $item -NoInvoke).Invoke($item)
    }
}
