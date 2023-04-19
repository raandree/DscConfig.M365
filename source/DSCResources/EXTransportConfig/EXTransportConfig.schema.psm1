configuration EXTransportConfig {
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $AddressBookPolicyRoutingEnabled,

        [Parameter()]
        [System.Boolean]
        $AllowLegacyTLSClients,

        [Parameter()]
        [System.Boolean]
        $ClearCategories,

        [Parameter()]
        [System.Boolean]
        $ConvertDisclaimerWrapperToEml,

        [Parameter()]
        [System.String]
        $DSNConversionMode,

        [Parameter()]
        [System.Boolean]
        $ExternalDelayDsnEnabled,

        [Parameter()]
        [System.String]
        $ExternalDsnDefaultLanguage,

        [Parameter()]
        [System.Boolean]
        $ExternalDsnLanguageDetectionEnabled,

        [Parameter()]
        [System.String]
        $ExternalDsnReportingAuthority,

        [Parameter()]
        [System.Boolean]
        $ExternalDsnSendHtml,

        [Parameter()]
        [System.String]
        $ExternalPostmasterAddress,

        [Parameter()]
        [System.String]
        $HeaderPromotionModeSetting,

        [Parameter()]
        [System.Boolean]
        $InternalDelayDsnEnabled,

        [Parameter()]
        [System.String]
        $InternalDsnDefaultLanguage,

        [Parameter()]
        [System.Boolean]
        $InternalDsnLanguageDetectionEnabled,

        [Parameter()]
        [System.String]
        $InternalDsnReportingAuthority,

        [Parameter()]
        [System.Boolean]
        $InternalDsnSendHtml,

        [Parameter()]
        [System.Int32]
        $JournalMessageExpirationDays,

        [Parameter()]
        [System.String]
        $JournalingReportNdrTo,

        [Parameter()]
        [System.String]
        $MaxRecipientEnvelopeLimit,

        [Parameter()]
        [System.Int32]
        $ReplyAllStormBlockDurationHours,

        [Parameter()]
        [System.Int32]
        $ReplyAllStormDetectionMinimumRecipients,

        [Parameter()]
        [System.Int32]
        $ReplyAllStormDetectionMinimumReplies,

        [Parameter()]
        [System.Boolean]
        $ReplyAllStormProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $Rfc2231EncodingEnabled,

        [Parameter()]
        [System.Boolean]
        $SmtpClientAuthenticationDisabled,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName Microsoft365DSC

    $param = $PSBoundParameters
    $param.Remove('InstanceName')
    (Get-DscSplattedResource -ResourceName EXOTransportConfig -ExecutionName AADGroupsSettingsInstance -Properties $param -NoInvoke).Invoke($param)

}
