configuration ADGroupSettings {
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableGroupCreation,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToBeGroupOwner,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToAccessGroups,

        [Parameter()]
        [System.String]
        $GuestUsageGuidelinesUrl,

        [Parameter()]
        [System.String]
        $GroupCreationAllowedGroupName,

        [Parameter()]
        [System.Boolean]
        $AllowToAddGuests,

        [Parameter()]
        [System.String]
        $UsageGuidelinesUrl,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName Microsoft365DSC

    $param = $PSBoundParameters
    $param.Remove('InstanceName')
    (Get-DscSplattedResource -ResourceName AADGroupsSettings -ExecutionName AADGroupsSettingsInstance -Properties $param -NoInvoke).Invoke($param)
}
