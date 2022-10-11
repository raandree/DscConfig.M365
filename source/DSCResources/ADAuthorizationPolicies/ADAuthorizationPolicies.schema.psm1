configuration ADAuthorizationPolicies {

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
        $AllowedToSignUpEmailBasedSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AllowedToUseSSPR,

        [Parameter()]
        [System.Boolean]
        $AllowEmailVerifiedUsersToJoinOrganization,

        [Parameter()]
        [System.String]
        [validateset('None', 'AdminsAndGuestInviters', 'AdminsGuestInvitersAndAllMembers', 'Everyone')]
        $AllowInvitesFrom,

        [Parameter()]
        [System.Boolean]
        $BlockMsolPowerShell,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateApps,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateSecurityGroups,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToReadOtherUsers,

        [Parameter()]
        [System.String[]]
        $PermissionGrantPolicyIdsAssignedToDefaultUserRole,

        [Parameter()]
        [validateset('User', 'Guest', 'RestrictedGuest')]
        [System.String]
        $GuestUserRole,

        #generic
        [Parameter()]
        [ValidateSet('Present')]
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
    (Get-DscSplattedResource -ResourceName AADAuthorizationPolicy -ExecutionName $DisplayName -Properties $param -NoInvoke).Invoke($param)
}
