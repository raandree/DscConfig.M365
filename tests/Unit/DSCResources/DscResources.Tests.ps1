BeforeDiscovery {
    $dscResources = Get-DscResource -Module $moduleUnderTest.Name
    $here = $PSScriptRoot

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

    $compositeResources = Get-DscResource -Module $moduleUnderTest.Name
    $finalTestCases = @()
    $finalTestCases += @{
        AllCompositeResources            = $compositeResources.Name
        FilteredCompositeResources       = $compositeResources | Where-Object Name -NotIn $skippedDscResources
        AllCompositeResourceFolders      = dir -Path "$($moduleUnderTest.ModuleBase)\DSCResources\*"
        FilteredCompositeResourceFolders = dir -Path "$($moduleUnderTest.ModuleBase)\DSCResources\*" | Where-Object BaseName -NotIn $skippedDscResources
    }
}

Describe 'DSC Composite Resources compile' -Tags FunctionalQuality {

    It "'<DscResourceName>' compiles" -TestCases $testCases {

        if ($Skip)
        {
            Set-ItResult -Skipped -Because "Tests for '$DscResourceName' are skipped"
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

        $dscConfiguration = $dscConfiguration.Replace('#<importStatements>', "Import-DscResource -Module $($moduleUnderTest.Name)")

        $dscConfiguration = $dscConfiguration.Replace('<DscResourceName>', $dscResourceName)
        Invoke-Expression -Command $dscConfiguration

        {
            TestConfig -ConfigurationData $configurationData -OutputPath $OutputDirectory -ErrorAction Stop
        } | Should -Not -Throw
    }

    It "'<DscResourceName>' should have created a mof file" -TestCases $testCases {

        if ($Skip)
        {
            Set-ItResult -Skipped -Because "Tests for '$DscResourceName' are skipped"
        }

        $mofFile = Get-Item -Path "$($OutputDirectory)\localhost_$DscResourceName.mof" -ErrorAction SilentlyContinue
        $mofFile | Should -BeOfType System.IO.FileInfo
    }

}

Describe 'Final tests' -Tags FunctionalQuality {

    It 'Every composite resource has compiled' -TestCases $finalTestCases {

        $mofFiles = Get-ChildItem -Path $OutputDirectory -Filter *.mof
        Write-Host "Number of compiled MOF files: $($mofFiles.Count)"
        $FilteredCompositeResources.Count | Should -Be $mofFiles.Count

    }

    It 'Composite resource folder count matches composite resource count' -TestCases $finalTestCases {

        Write-Host "Number of composite resource folders: $($AllCompositeResourceFolders.Count)"
        Write-Host "Number of composite resource folders (considering 'skippedDscResources'): $($FilteredCompositeResourceFolders.Count)"
        Write-Host "Number of all composite resources: $($AllCompositeResources.Count)"
        Write-Host "Number of composite resources (considering 'skippedDscResources'): $($FilteredCompositeResources.Count)"

        Write-Host (Compare-Object -ReferenceObject $FilteredCompositeResourceFolders.BaseName -DifferenceObject $FilteredCompositeResources.Name | Out-String) -ForegroundColor Yellow

        $FilteredCompositeResourceFolders.Count | Should -Be $FilteredCompositeResources.Count

    }
}
