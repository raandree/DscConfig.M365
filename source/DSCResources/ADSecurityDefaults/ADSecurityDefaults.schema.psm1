configuration ADSecurityDefaults {

    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

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
    (Get-DscSplattedResource -ResourceName AADSecurityDefaults -ExecutionName $DisplayName -Properties $param -NoInvoke).Invoke($param)
}
