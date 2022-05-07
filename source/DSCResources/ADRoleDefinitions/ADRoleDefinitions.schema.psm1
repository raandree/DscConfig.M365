configuration ADRoleDefinitions {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADRoleDefinition [String] #ResourceName
{
    DisplayName = [string]
    IsEnabled = [bool]
    RolePermissions = [string[]]
    [ApplicationId = [string]]
    [ApplicationSecret = [string]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Description = [string]]
    [Ensure = [string]{ Absent | Present }]
    [Id = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [ResourceScopes = [string[]]]
    [TemplateId = [string]]
    [TenantId = [string]]
    [Version = [string]]
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

        $executionName = "$($item.Displayname)_$($item.RolePermissions)_$($item.IsEnabled)"
        (Get-DscSplattedResource -ResourceName AADRoleDefinition -ExecutionName $executionName -Properties $item -NoInvoke).Invoke($item)
    }
}
