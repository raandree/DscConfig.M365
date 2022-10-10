configuration ADRoleSettings {
    param (
        [Parameter()]
        [hashtable[]]
        $Items
    )

<#
AADRoleSetting [String] #ResourceName
{
    Id = [string]
    [ActivateApprover = [string[]]]
    [ActivationMaxDuration = [string]]
    [ActivationReqJustification = [bool]]
    [ActivationReqMFA = [bool]]
    [ActivationReqTicket = [bool]]
    [ActiveAlertNotificationAdditionalRecipient = [string[]]]
    [ActiveAlertNotificationDefaultRecipient = [bool]]
    [ActiveAlertNotificationOnlyCritical = [bool]]
    [ActiveApproveNotificationAdditionalRecipient = [string[]]]
    [ActiveApproveNotificationDefaultRecipient = [bool]]
    [ActiveApproveNotificationOnlyCritical = [bool]]
    [ActiveAssigneeNotificationAdditionalRecipient = [string[]]]
    [ActiveAssigneeNotificationDefaultRecipient = [bool]]
    [ActiveAssigneeNotificationOnlyCritical = [bool]]
    [ApplicationId = [string]]
    [ApplicationSecret = [PSCredential]]
    [ApprovaltoActivate = [bool]]
    [AssignmentReqJustification = [bool]]
    [AssignmentReqMFA = [bool]]
    [CertificateThumbprint = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Displayname = [string]]
    [ElegibilityAssignmentReqJustification = [bool]]
    [ElegibilityAssignmentReqMFA = [bool]]
    [EligibleAlertNotificationAdditionalRecipient = [string[]]]
    [EligibleAlertNotificationDefaultRecipient = [bool]]
    [EligibleAlertNotificationOnlyCritical = [bool]]
    [EligibleApproveNotificationAdditionalRecipient = [string[]]]
    [EligibleApproveNotificationDefaultRecipient = [bool]]
    [EligibleApproveNotificationOnlyCritical = [bool]]
    [EligibleAssigneeNotificationAdditionalRecipient = [string[]]]
    [EligibleAssigneeNotificationDefaultRecipient = [bool]]
    [EligibleAssigneeNotificationOnlyCritical = [bool]]
    [EligibleAssignmentAlertNotificationAdditionalRecipient = [string[]]]
    [EligibleAssignmentAlertNotificationDefaultRecipient = [bool]]
    [EligibleAssignmentAlertNotificationOnlyCritical = [bool]]
    [EligibleAssignmentAssigneeNotificationAdditionalRecipient = [string[]]]
    [EligibleAssignmentAssigneeNotificationDefaultRecipient = [bool]]
    [EligibleAssignmentAssigneeNotificationOnlyCritical = [bool]]
    [Ensure = [string]{ Absent | Present }]
    [ExpireActiveAssignment = [string]]
    [ExpireEligibleAssignment = [string]]
    [ManagedIdentity = [bool]]
    [PermanentActiveAssignmentisExpirationRequired = [bool]]
    [PermanentEligibleAssignmentisExpirationRequired = [bool]]
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

        (Get-DscSplattedResource -ResourceName AADRoleSetting -ExecutionName $item.Id -Properties $item -NoInvoke).Invoke($item)
    }
}
