<#
    .SYNOPSIS
        Sets the encoding of all *.psd1 files to UTF8.

    .DESCRIPTION
        Sets the encoding of all *.psd1 files to UTF8. This is a build task that is

        This task is only needed when the build runs on Windows PowerShell 5.1.

    .NOTES
        This is a build task that is primarily meant to be run by Invoke-Build but
        wrapped by the Sampler project's build.ps1 (https://github.com/gaelcolas/Sampler).
#>

param ()

function ConvertTo-PowerShellType
{
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TypeName
    )

    switch ($TypeName)
    {
        'Boolean'
        {
            return 'bool'
        }
        'DateTime'
        {
            return 'datetime'
        }
        'MSFT_Credential'
        {
            return 'PSCredential'
        }
        'SInt32'
        {
            return 'int'
        }
        'SInt64'
        {
            return 'long'
        }
        'String'
        {
            return 'string'
        }
        'StringArray'
        {
            return 'string[]'
        }
        'UInt16'
        {
            return 'System.UInt16'
        }
        'UInt32'
        {
            return 'System.UInt32'
        }

        default
        {
            # Embedded CIM instances have no PowerShell type. They are passed as hashtables.
            if ($TypeName -match '^MSFT_(?<name>\w+)(?<array>\[\])?$')
            {
                if ($Matches.name -eq 'Credential')
                {
                    return "PSCredential$($Matches.array)"
                }

                return "hashtable$($Matches.array)"
            }

            return $TypeName
        }
    }
}

function New-DscCompositeResourcePsd1Code
{
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $CompositeResourceName,

        [Parameter(Mandatory = $true)]
        [string]
        $CompositeResourceModuleName
    )

    #Calculate a GUID based on the name of the resource and the module name
    $combinedName = $CompositeResourceName + $CompositeResourceModuleName
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $combinedNameBytes = [System.Text.Encoding]::ASCII.GetBytes($combinedName)
    $hashBytes = $md5.ComputeHash($combinedNameBytes)
    $guid = [guid]::new($hashBytes)

    $code = [System.Text.StringBuilder]::new()

    [void]$code.AppendLine('@{')
    [void]$code.AppendLine("    RootModule           = '$CompositeResourceName.schema.psm1'")
    [void]$code.AppendLine('')
    [void]$code.AppendLine("    ModuleVersion        = '0.0.1'")
    [void]$code.AppendLine('')
    [void]$code.AppendLine("    GUID                 = '$guid'")
    [void]$code.AppendLine('')
    [void]$code.AppendLine("    Author               = 'DscCommunity'")
    [void]$code.AppendLine('')
    [void]$code.AppendLine("    CompanyName          = 'DscCommunity'")
    [void]$code.AppendLine('')
    [void]$code.AppendLine("    Copyright            = 'DscCommunity'")
    [void]$code.AppendLine('')
    [void]$code.AppendLine("    DscResourcesToExport = @('$CompositeResourceName')")
    [void]$code.AppendLine('}')

    $code.ToString()

}

function New-DscCompositeResourceCode
{
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $CompositeResourceName,

        [Parameter(Mandatory = $true)]
        [string]
        $DscResourceName,

        [Parameter(Mandatory = $true)]
        [string]
        $DscResourceModuleName,

        [Parameter()]
        [version]
        $DscResourceModuleVersion,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Scalar', 'Array')]
        [string]
        $ParameterType
    )

    $code = [System.Text.StringBuilder]::new()
    [void]$code.AppendLine("configuration $CompositeResourceName {")
    [void]$code.AppendLine('    param (')

    $m = Import-Module -Name DscBuildHelpers -Force -PassThru
    $dscParameters = & $m {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $DscResourceModuleName,

            [Parameter()]
            [version]
            $DscResourceModuleVersion,

            [Parameter(Mandatory = $true)]
            [string]
            $DscResourceName
        )

        # Multiple versions can be present in PSModulePath; Get-DscResourceProperty expects a single PSModuleInfo.
        $moduleCandidates = Get-Module -Name $DscResourceModuleName -ListAvailable
        if ($PSBoundParameters.ContainsKey('DscResourceModuleVersion'))
        {
            $moduleInfo = $moduleCandidates |
                Where-Object -FilterScript { $_.Version -eq $DscResourceModuleVersion } |
                    Select-Object -First 1
                }
                else
                {
                    $moduleInfo = $moduleCandidates |
                        Sort-Object -Property Version -Descending |
                            Select-Object -First 1
                        }

                        if (-not $moduleInfo)
                        {
                            if ($PSBoundParameters.ContainsKey('DscResourceModuleVersion'))
                            {
                                throw "Could not find DSC resource module '$DscResourceModuleName' with version '$DscResourceModuleVersion' in PSModulePath."
                            }

                            throw "Could not find DSC resource module '$DscResourceModuleName' in PSModulePath."
                        }

                        Get-DscResourceProperty -ModuleInfo $moduleInfo -ResourceName $DscResourceName
                    } -DscResourceModuleName $DscResourceModuleName -DscResourceModuleVersion $DscResourceModuleVersion -DscResourceName $DscResourceName |
                        Where-Object -FilterScript { $_.Name -notin 'PsDscRunAsCredential', 'DependsOn' }

    if (-not $dscParameters)
    {
        Write-Error "DSC Resource '$DscResourceName' not found in module '$DscResourceModuleName'."
    }

    if ($parameterType -eq 'Array')
    {
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [hashtable[]]')
        [void]$code.AppendLine('        $Items,')

        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [string]')
        [void]$code.AppendLine('        $TenantId,')
        [void]$code.AppendLine('')
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [bool]')
        [void]$code.AppendLine('        $ManagedIdentity,')
        [void]$code.AppendLine('')
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [pscredential]')
        [void]$code.AppendLine('        $Credential,')
        [void]$code.AppendLine('')
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [string]')
        [void]$code.AppendLine('        $CertificateThumbprint,')
        [void]$code.AppendLine('')
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [pscredential]')
        [void]$code.AppendLine('        $ApplicationSecret,')
        [void]$code.AppendLine('')
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [string]')
        [void]$code.AppendLine('        $ApplicationId,')
        [void]$code.AppendLine('')
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [string[]]')
        [void]$code.AppendLine('        $AccessTokens,')
    }
    else
    {
        foreach ($dscParameter in $dscParameters)
        {
            $type = ConvertTo-PowerShellType -TypeName $dscParameter.TypeConstraint
            $isMandatory = if ($dscParameter.Mandatory -or $dscParameter.IsKey)
            {
                $true
            }
            [void]$code.AppendLine("        [Parameter($(if ($isMandatory) { 'Mandatory = $true' } ))]")
            if ($dscParameter.Values)
            {
                [void]$code.AppendLine("        [ValidateSet('$(($dscParameter.Values -split ',').ForEach({$_.Trim()}) -join "', '")')]")
            }
            [void]$code.AppendLine("        [$($type)]")
            [void]$code.AppendLine("        `$$($dscParameter.Name),")
            [void]$code.AppendLine('')
        }
    }
    $lastIndexOfComma = $code.ToString().LastIndexOf(',')
    [void]$code.Remove($lastIndexOfComma, $code.Length - $lastIndexOfComma)
    [void]$code.AppendLine('')
    [void]$code.AppendLine(')')

    [void]$code.AppendLine('')
    [void]$code.AppendLine('<#')
    $dscResourceSyntax = $dscResourceSyntax.Where({ $_.ResourceName -eq $DscResourceName }) -split "`n"
    foreach ($line in $dscResourceSyntax)
    {
        [void]$code.AppendLine($line)
    }
    [void]$code.AppendLine('#>')
    [void]$code.AppendLine('')

    [void]$code.AppendLine('')
    [void]$code.AppendLine('    Import-DscResource -ModuleName PSDesiredStateConfiguration')
    [void]$code.AppendLine("    Import-DscResource -ModuleName $DscResourceModuleName")
    [void]$code.AppendLine('')

    [void]$code.AppendLine("    `$dscResourceName = '$DscResourceName'")
    [void]$code.AppendLine('')

    [void]$code.AppendLine('    $param = $PSBoundParameters')
    [void]$code.AppendLine('    $param.Remove("InstanceName")')
    [void]$code.AppendLine('')

    $dscParameterKeys = $dscParameters.Where({ $_.IsKey })
    [void]$code.AppendLine('    $dscParameterKeys = ''{0}'' -split '', ''' -f ($dscParameterKeys.Name -join ', '))
    [void]$code.AppendLine('')

    if ($ParameterType -eq 'Scalar')
    {
        [void]$code.AppendLine('    $keyValues = foreach ($key in $dscParameterKeys)')
        [void]$code.AppendLine('    {')
        [void]$code.AppendLine('        $param.$key')
        [void]$code.AppendLine('    }')
        [void]$code.AppendLine('    $executionName = $keyValues -join ''_''')
        [void]$code.AppendLine('    $executionName = $executionName -replace "[\s()\\:*-+/{}```"'']", ''_''')
        [void]$code.AppendLine('')

        [void]$code.AppendLine('    (Get-DscSplattedResource -ResourceName $dscResourceName -ExecutionName $executionName -Properties $param -NoInvoke).Invoke($param)')
        [void]$code.AppendLine('')
    }
    else
    {
        [void]$code.AppendLine('        foreach ($item in $Items)')
        [void]$code.AppendLine('        {')

        if ($dscParameters.Where({ $_.Name -eq 'Ensure' }))
        {
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''Ensure''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.Ensure = ''Present''')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''TenantId'') -and $param.ContainsKey(''TenantId''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.TenantId = $TenantId')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''ManagedIdentity'') -and $param.ContainsKey(''ManagedIdentity''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.ManagedIdentity = $ManagedIdentity')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''Credential'') -and $param.ContainsKey(''Credential''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.Credential = $Credential')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''CertificateThumbprint'') -and $param.ContainsKey(''CertificateThumbprint''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.CertificateThumbprint = $CertificateThumbprint')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''ApplicationSecret'') -and $param.ContainsKey(''ApplicationSecret''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.ApplicationSecret = $ApplicationSecret')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''ApplicationId'') -and $param.ContainsKey(''ApplicationId''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.ApplicationId = $ApplicationId')
            [void]$code.AppendLine('            }')
            [void]$code.AppendLine('')
            [void]$code.AppendLine('            if (-not $item.ContainsKey(''AccessTokens'') -and $param.ContainsKey(''AccessTokens''))')
            [void]$code.AppendLine('            {')
            [void]$code.AppendLine('                $item.AccessTokens = $AccessTokens')
            [void]$code.AppendLine('            }')
        }
        [void]$code.AppendLine('            $keyValues = foreach ($key in $dscParameterKeys)')
        [void]$code.AppendLine('        {')
        [void]$code.AppendLine('            $item.$key')
        [void]$code.AppendLine('        }')
        [void]$code.AppendLine('        $executionName = $keyValues -join ''_''')
        [void]$code.AppendLine('        $executionName = $executionName -replace "[\s()\\:*-+/{}```"'']", ''_''')
        [void]$code.AppendLine('        (Get-DscSplattedResource -ResourceName $dscResourceName -ExecutionName $executionName -Properties $item -NoInvoke).Invoke($item)')
        [void]$code.AppendLine('    }')
    }

    [void]$code.AppendLine('}')

    $code.ToString()
}

task Create_Dsc_Composite_Resources {

    $requiredModulesPath = Join-Path -Path $BuildRoot -ChildPath 'RequiredModules.psd1'
    $requiredModules = Import-PowerShellDataFile -Path $requiredModulesPath
    $microsoft365DscVersion = [version] $requiredModules.Microsoft365DSC

    Remove-Item -Path $SourcePath\DSCResources -Recurse -Force -ErrorAction SilentlyContinue
    mkdir -Path $SourcePath\DSCResources -Force | Out-Null

    $dscResourceModules = Get-Content -Path $SourcePath\DSCResources.yml -Raw | ConvertFrom-Yaml

    $originalPsModulePath = $env:PSModulePath

    foreach ($dscResourceModule in $dscResourceModules.GetEnumerator())
    {
        #Get syntax for all DSC Resources in the module. Getting them one by one is too slow.
        if ($dscResourceModule.Name -eq 'Microsoft365DSC')
        {
            $moduleSpec = @{
                ModuleName    = $dscResourceModule.Name
                ModuleVersion = $microsoft365DscVersion
            }

            # Avoid duplicate CIM class definitions when the same version exists in system module paths.
            $env:PSModulePath = ($originalPsModulePath -split ';' | Where-Object {
                    $_ -and $_ -notmatch '^[A-Za-z]:\\Program Files\\(WindowsPowerShell|PowerShell)\\Modules'
                }) -join ';'

            $dscResourceSyntax = Get-DscResource -Module $moduleSpec -Syntax

            $env:PSModulePath = $originalPsModulePath
        }
        else
        {
            $dscResourceSyntax = Get-DscResource -Module $dscResourceModule.Name -Syntax
        }
        $dscResourceSyntax | Add-Member -Name ResourceName -MemberType ScriptProperty -Value { ($this -split ' ')[0] }

        foreach ($dscResource in $dscResourceModule.Value.GetEnumerator())
        {
            $param = @{
                DscResourceModuleName = $dscResourceModule.Name
                DscResourceName       = $dscResource.Name
                CompositeResourceName = $dscResource.Value.CompositeResourceName
                ParameterType         = $dscResource.Value.ParameterType
            }

            if ($dscResourceModule.Name -eq 'Microsoft365DSC')
            {
                $param.DscResourceModuleVersion = $microsoft365DscVersion
            }

            $utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)

            Write-Build DarkGray "Generating code DSC Composite Resource '$($dscResource.Value.CompositeResourceName)' for DSC Resource '$($dscResource.Name)'."
            $compositeResourceCode = New-DscCompositeResourceCode @param
            mkdir -Path "$SourcePath\DSCResources\$($param.CompositeResourceName)" -Force | Out-Null
            [System.IO.File]::WriteAllLines("$SourcePath\DSCResources\$($param.CompositeResourceName)\$($param.CompositeResourceName).schema.psm1", $compositeResourceCode, $utf8NoBomEncoding)

            $compositeResourcePsd1Code = New-DscCompositeResourcePsd1Code -CompositeResourceName $dscResource.Value.CompositeResourceName -CompositeResourceModuleName $ProjectName
            [System.IO.File]::WriteAllLines("$SourcePath\DSCResources\$($param.CompositeResourceName)\$($param.CompositeResourceName).psd1", $compositeResourcePsd1Code, $utf8NoBomEncoding)
        }

    }

    $env:PSModulePath = $originalPsModulePath

}
