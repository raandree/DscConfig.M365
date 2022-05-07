configuration ADTenantDetails {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

    <#
AADTenantDetails [String] #ResourceName
{
    IsSingleInstance = [string]{ Yes }
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [MarketingNotificationEmails = [string[]]]
    [PsDscRunAsCredential = [PSCredential]]
    [SecurityComplianceNotificationMails = [string[]]]
    [SecurityComplianceNotificationPhones = [string[]]]
    [TechnicalNotificationMails = [string[]]]
    [TenantId = [string]]
}
#>

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName Microsoft365DSC

    foreach ($item in $Items)
    {
        $executionName = if ($null -ne $item.TenantId)
        {
            $item.TenantId
        }
        else
        {
            ($item.Credential.UserName -split '@')[1]
        }

        (Get-DscSplattedResource -ResourceName AADTenantDetails -ExecutionName $executionName -Properties $item -NoInvoke).Invoke($item)
    }
}
