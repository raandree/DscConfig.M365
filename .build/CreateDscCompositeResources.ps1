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

function ConvertTo-PowerShellType {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TypeName
    )

    switch ($TypeName) {
        'Boolean' { return 'bool' }
        'DateTime' { return 'datetime' }
        'MSFT_Credential' { return 'PSCredential' }
        'SInt32' { return 'int' }
        'SInt64' { return 'long' }
        'String' { return 'string' }
        'StringArray' { return 'string[]' }
        'UInt16' { return 'System.UInt16' }
        'UInt32' { return 'System.UInt32' }
        
        default { return $TypeName }
    }
}

function New-DscCompositeResourcePsd1Code {
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

function New-DscCompositeResourceCode {
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

        [Parameter(Mandatory = $true)]
        [ValidateSet('Scalar', 'Array')]
        [string]
        $ParameterType
    )

    $code = [System.Text.StringBuilder]::new()
    [void]$code.AppendLine("configuration $CompositeResourceName {")
    [void]$code.AppendLine('    param (')

    $dscParameters = Get-DscResourceProperty -ModuleInfo (Get-Module -Name $DscResourceModuleName -ListAvailable) -ResourceName $DscResourceName |
        Where-Object -FilterScript { $_.Name -notin 'PsDscRunAsCredential', 'DependsOn' }
    
    if (-not $dscParameters) {
        Write-Error "DSC Resource '$DscResourceName' not found in module '$DscResourceModuleName'."
    }
    
    if ($parameterType -eq 'Array') {
        [void]$code.AppendLine('        [Parameter()]')
        [void]$code.AppendLine('        [hashtable[]]')
        [void]$code.AppendLine('        $Items,')
    }
    else {
        foreach ($dscParameter in $dscParameters) {
            $type = ConvertTo-PowerShellType -TypeName $dscParameter.TypeConstraint
            $isMandatory = if ($dscParameter.Mandatory -or $dscParameter.IsKey) { $true }
            [void]$code.AppendLine("        [Parameter($(if ($isMandatory) { 'Mandatory = $true' } ))]")
            if ($dscParameter.Values) {
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
    foreach ($line in $dscResourceSyntax) {
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

    if ($ParameterType -eq 'Scalar') {
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
    else {
        [void]$code.AppendLine('        foreach ($item in $Items)')
        [void]$code.AppendLine('        {')
        [void]$code.AppendLine('            if (-not $item.ContainsKey(''Ensure''))')
        [void]$code.AppendLine('            {')
        [void]$code.AppendLine('                $item.Ensure = ''Present''')
        [void]$code.AppendLine('            }')
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

    Remove-Item -Path $SourcePath\DSCResources -Recurse -Force -ErrorAction SilentlyContinue
    mkdir -Path $SourcePath\DSCResources -Force | Out-Null

    $dscResourceModules = Get-Content -Path $SourcePath\DSCResources.yml -Raw | ConvertFrom-Yaml

    foreach ($dscResourceModule in $dscResourceModules.GetEnumerator()) {

        #Get syntax for all DSC Resources in the module. Getting them one by one is too slow.
        $dscResourceSyntax = Get-DscResource -Module $dscResourceModule.Name -Syntax
        $dscResourceSyntax | Add-Member -Name ResourceName -MemberType ScriptProperty -Value { ($this -split ' ')[0] }
    
        foreach ($dscResource in $dscResourceModule.Value.GetEnumerator()) {
            $param = @{
                DscResourceModuleName = $dscResourceModule.Name
                DscResourceName       = $dscResource.Name
                CompositeResourceName = $dscResource.Value.CompositeResourceName
                ParameterType         = $dscResource.Value.ParameterType
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

}
