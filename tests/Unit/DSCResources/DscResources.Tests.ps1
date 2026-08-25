BeforeDiscovery {

    if ($PSVersionTable.PSEdition -eq 'Desktop')
    {
        Write-Host 'Running on Windows PowerShell, removing PSDesiredStateConfiguration module from the required modules directory.'
        Remove-Item $RequiredModulesDirectory\PSDesiredStateConfiguration -Recurse -Force -ErrorAction SilentlyContinue
    }

    $dscResources = Get-DscResource -Module $moduleUnderTest.Name
    $here = $PSScriptRoot
    mkdir -Path $OutputDirectory\MOF -Force | Out-Null

    $skippedDscResources = ''

    Import-Module -Name datum

    $datum = New-DatumStructure -DefinitionFile $here\Assets\Datum.yml
    $allNodes = Get-Content -Path $here\Assets\AllNodes.yml -Raw | ConvertFrom-Yaml

    Write-Host 'Reading DSC Resource metadata for supporting CIM based DSC parameters...'
    Initialize-DscResourceMetaInfo -ModulePath $RequiredModulesDirectory
    Write-Host 'Done'

    $global:configurationData = @{
        AllNodes = [array]$allNodes
        Datum    = $Datum
    }

    [hashtable[]]$testCases = @()
    foreach ($dscResource in $dscResources)
    {
        [PSCustomObject]$dscResourceModuleTable = @()
        $testCases += @{
            DscResourceName = $dscResource.Name
            Skip            = ($dscResource.Name -in $skippedDscResources)
        }
    }

    if (-not $testCases)
    {
        # Keep discovery stable in environments where Get-DscResource returns no entries for the built module.
        $testCases += @{
            DscResourceName = '_NoDiscoveredResource'
            Skip            = $true
        }
    }

    $compositeResources = Get-DscResource -Module $moduleUnderTest.Name
    $expectedCompositeResourceNames = @()

    $repositoryRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -Parent
    $dscResourcesYamlPath = Join-Path -Path $repositoryRoot -ChildPath 'source\DSCResources.yml'

    if (Test-Path -Path $dscResourcesYamlPath)
    {
        $dscResourcesYaml = Get-Content -Path $dscResourcesYamlPath -Raw | ConvertFrom-Yaml

        if ($dscResourcesYaml -and $dscResourcesYaml.Microsoft365DSC)
        {
            $expectedCompositeResourceNames = @(
                $dscResourcesYaml.Microsoft365DSC.GetEnumerator() |
                    ForEach-Object { $_.Value.CompositeResourceName } |
                        Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            )
        }
    }

    $compositeResourcePath = Join-Path -Path $moduleUnderTest.ModuleBase -ChildPath 'DSCResources'
    $hasCompositeResourcePath = Test-Path -Path $compositeResourcePath -PathType Container

    $allCompositeResourceFolders = @()
    $filteredCompositeResourceFolders = @()

    if ($hasCompositeResourcePath)
    {
        $allCompositeResourceFolders = @(Get-ChildItem -Path "$compositeResourcePath\*" -ErrorAction SilentlyContinue)
        $filteredCompositeResourceFolders = @($allCompositeResourceFolders | Where-Object BaseName -NotIn $skippedDscResources)
    }

    $finalTestCases = @()
    $finalTestCases += @{
        AllCompositeResources            = $compositeResources.Name
        FilteredCompositeResources       = $compositeResources | Where-Object Name -NotIn $skippedDscResources
        ExpectedCompositeResourceNames   = $expectedCompositeResourceNames
        AllCompositeResourceFolders      = $allCompositeResourceFolders
        FilteredCompositeResourceFolders = $filteredCompositeResourceFolders
        CompositeResourcePath            = $compositeResourcePath
        HasCompositeResourcePath         = $hasCompositeResourcePath
    }
}

Describe 'DSC Composite Resources compile' -Tags FunctionalQuality {

    It "'<DscResourceName>' compiles" -TestCases $testCases {

        if ($Skip)
        {
            Set-ItResult -Skipped -Because "Tests for '$DscResourceName' are skipped"
            return
        }

        $nodeData = @{
            NodeName                    = "localhost_$dscResourceName"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true
        }
        $configurationData.AllNodes = @($nodeData)

        $dscConfiguration = @'
configuration TestConfig {

    #<importStatements>

    node "localhost_<DscResourceName>" {

        $data = $configurationData.Datum.Config.<DscResourceName>
        if (-not $data)
        {
            $data = @{}
        }

        (Get-DscSplattedResource -ResourceName <DscResourceName> -ExecutionName _<DscResourceName> -Properties $data -NoInvoke).Invoke($data)
    }
}
'@

        $dscConfiguration = $dscConfiguration.Replace('#<importStatements>', "Import-DscResource -ModuleName $($moduleUnderTest.Name) -Name $DscResourceName")

        $dscConfiguration = $dscConfiguration.Replace('<DscResourceName>', $dscResourceName)
        Invoke-Expression -Command $dscConfiguration

        {
            TestConfig -ConfigurationData $configurationData -OutputPath $OutputDirectory\MOF -ErrorAction Stop
        } | Should -Not -Throw
    }

    It "'<DscResourceName>' should have created a mof file" -TestCases $testCases {

        if ($Skip)
        {
            Set-ItResult -Skipped -Because "Tests for '$DscResourceName' are skipped"
            return
        }

        $mofFile = Get-Item -Path "$($OutputDirectory)\MOF\localhost_$DscResourceName.mof" -ErrorAction SilentlyContinue
        $mofFile | Should -BeOfType System.IO.FileInfo
    }

    It "'<DscResourceName>' MOF file should contain Azure connection data" -TestCases $testCases {

        if ($Skip)
        {
            Set-ItResult -Skipped -Because "Tests for '$DscResourceName' are skipped"
            return
        }

        $mofFile = Get-Content -Path "$($OutputDirectory)\MOF\localhost_$DscResourceName.mof" -ErrorAction SilentlyContinue
        $result = $mofFile -match 'instance of MSFT_Credential' -or
        $mofFile -match 'CertificateThumbprint = "[0-9a-fA-F]{40}"'

        $result | Should -Be $true
    }

}

Describe 'Final tests' -Tags FunctionalQuality {

    It 'Every composite resource has compiled' -TestCases $finalTestCases {

        if (-not $HasCompositeResourcePath)
        {
            Set-ItResult -Skipped -Because "Composite resource folder '$CompositeResourcePath' was not found."
            return
        }

        $mofFiles = Get-ChildItem -Path $OutputDirectory\MOF -Filter *.mof
        Write-Host "Number of compiled MOF files: $($mofFiles.Count)"
        $expectedCount = [int]$FilteredCompositeResources.Count
        $actualCount = [int]$mofFiles.Count

        if ($actualCount -ne $expectedCount)
        {
            throw "Expected $expectedCount compiled MOF files but found $actualCount."
        }

    }

    It 'Composite resource folder count matches composite resource count' -TestCases $finalTestCases {

        if (-not $HasCompositeResourcePath)
        {
            Set-ItResult -Skipped -Because "Composite resource folder '$CompositeResourcePath' was not found."
            return
        }

        $folderNames = @($FilteredCompositeResourceFolders | ForEach-Object BaseName)

        $resourceNames = if ($ExpectedCompositeResourceNames -and $ExpectedCompositeResourceNames.Count -gt 0)
        {
            @($ExpectedCompositeResourceNames)
        }
        else
        {
            @($FilteredCompositeResources | ForEach-Object Name)
        }

        # Normalize to non-null string arrays to avoid ParameterBindingValidationException in Compare-Object.
        [string[]]$folderNames = @($folderNames | Where-Object { $null -ne $_ -and $_ -ne '' })
        [string[]]$resourceNames = @($resourceNames | Where-Object { $null -ne $_ -and $_ -ne '' })

        Write-Host "Number of composite resource folders: $($AllCompositeResourceFolders.Count)"
        Write-Host "Number of composite resource folders (considering 'skippedDscResources'): $($FilteredCompositeResourceFolders.Count)"
        Write-Host "Number of all composite resources: $($AllCompositeResources.Count)"
        Write-Host "Number of composite resources (considering 'skippedDscResources'): $($FilteredCompositeResources.Count)"
        Write-Host "Normalized composite resource folder names count: $($folderNames.Count)"
        Write-Host "Normalized composite resource names count: $($resourceNames.Count)"

        $missingFolders = @($resourceNames | Where-Object { $_ -notin $folderNames })
        $extraFolders = @($folderNames | Where-Object { $_ -notin $resourceNames })

        if ($missingFolders.Count -gt 0)
        {
            Write-Host ('Missing composite resource folders: {0}' -f ($missingFolders -join ', ')) -ForegroundColor Yellow
        }

        if ($extraFolders.Count -gt 0)
        {
            Write-Host ('Extra composite resource folders: {0}' -f ($extraFolders -join ', ')) -ForegroundColor Yellow
        }

        $expectedCount = [int]$resourceNames.Count
        $actualCount = [int]$folderNames.Count

        if ($actualCount -ne $expectedCount)
        {
            throw "Composite folder/resource count mismatch. Folders: $actualCount, Resources: $expectedCount."
        }

    }
}
