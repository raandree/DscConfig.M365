task Create_DSC_Resource_Yaml_File {

    if (-not $dscResources) {

        $dscResources = 'AADTenantDetails',
        'AADConditionalAccessPolicy',
        'AADNamedLocationPolicy',
        'AADGroupsSettings',
        'EXOTransportConfig',
        'AADGroup',
        'AADRoleSetting',
        'AADSecurityDefaults',
        'AADAuthorizationPolicy',
        'AADApplication',
        'AADGroupLifecyclePolicy',
        'AADGroupsNamingPolicy',
        'AADTokenLifetimePolicy',
        'AADRoleDefinition',
        'AADServicePrincipal'

        $dscResources = Get-DscResource -Module Microsoft365DSC | Where-Object Name -In $dscResources

    }
    $scalar = $dscResources | Where-Object { $_.Properties.Name -contains 'IsSingleInstance' }
    $array = $dscResources | Where-Object { $_.Properties.Name -notcontains 'IsSingleInstance' }

    $content = @{
        Microsoft365DSC = [ordered]@{}
    }

    foreach ($item in $scalar) {
        $compositeName = "c$($item.Name)" #Get-Name -Name $item.Name
        $content.Microsoft365DSC.Add($item.Name, @{
                CompositeResourceName = $compositeName
                ParameterType         = 'Scalar'
            })
    }
    foreach ($item in $array) {
        $compositeName = "c$($item.Name)" #Get-Name -Name $item.Name
        $content.Microsoft365DSC.Add($item.Name, @{
                CompositeResourceName = $compositeName
                ParameterType         = 'Array'
            })
    }

    #$content.Microsoft365DSC | ft -Property Name, @{ Label = 'CompositeName'; Expression = { $_.Value.ParameterType } }

    $utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines("$sourcePath\DSCResources.yml", ($content | ConvertTo-Yaml), $utf8NoBomEncoding)

}