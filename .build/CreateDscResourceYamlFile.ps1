task Create_Dsc_Resource_Yaml_File {

    $requiredModulesPath = Join-Path -Path $BuildRoot -ChildPath 'RequiredModules.psd1'
    $requiredModules = Import-PowerShellDataFile -Path $requiredModulesPath
    $microsoft365DscVersion = [version] $requiredModules.Microsoft365DSC
    $microsoft365DscModuleSpec = @{
        ModuleName    = 'Microsoft365DSC'
        ModuleVersion = $microsoft365DscVersion
    }

    if (-not $dscResources)
    {
        $path = Get-SamplerAbsolutePath -Path tests\Unit\DSCResources\Assets\Config -RelativeTo $BuildRoot
        $dscResources = Get-ChildItem -Path $path -Filter *.y*ml | ForEach-Object { $_.BaseName.Substring(1) }

        $originalPsModulePath = $env:PSModulePath
        $env:PSModulePath = ($originalPsModulePath -split ';' | Where-Object {
                $_ -and $_ -notmatch '^[A-Za-z]:\\Program Files\\(WindowsPowerShell|PowerShell)\\Modules'
            }) -join ';'

        $dscResources = if ($dscResources)
        {
            Get-DscResource -Module $microsoft365DscModuleSpec | Where-Object Name -In $dscResources
        }
        else
        {
            Get-DscResource -Module $microsoft365DscModuleSpec
        }

        $env:PSModulePath = $originalPsModulePath

    }
    $scalar = $dscResources | Where-Object { $_.Properties.Name -contains 'IsSingleInstance' }
    $array = $dscResources | Where-Object { $_.Properties.Name -notcontains 'IsSingleInstance' }

    $content = @{
        Microsoft365DSC = [ordered]@{}
    }

    foreach ($item in $scalar)
    {
        $compositeName = "c$($item.Name)"
        $content.Microsoft365DSC.Add($item.Name,
            @{
                CompositeResourceName = $compositeName
                ParameterType         = 'Scalar'
            })
    }
    foreach ($item in $array)
    {
        $compositeName = "c$($item.Name)"
        $content.Microsoft365DSC.Add($item.Name,
            @{
                CompositeResourceName = $compositeName
                ParameterType         = 'Array'
            })
    }

    $utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines("$sourcePath\DSCResources.yml", ($content | ConvertTo-Yaml), $utf8NoBomEncoding)

}
