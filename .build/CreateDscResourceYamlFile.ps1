task Create_DSC_Resource_Yaml_File {

    if (-not $dscResources)
    {
        $path = Get-SamplerAbsolutePath -Path tests\Unit\DSCResources\Assets\Config -RelativeTo $BuildRoot
        $dscResources = dir -Path $path -Filter *.y*ml | ForEach-Object { $_.BaseName.Substring(1) }

        $dscResources = if ($dscResources)
        {
            Get-DscResource -Module Microsoft365DSC | Where-Object Name -In $dscResources
        }
        else
        {
            Get-DscResource -Module Microsoft365DSC
        }

    }
    $scalar = $dscResources | Where-Object { $_.Properties.Name -contains 'IsSingleInstance' }
    $array = $dscResources | Where-Object { $_.Properties.Name -notcontains 'IsSingleInstance' }

    $content = @{
        Microsoft365DSC = [ordered]@{}
    }

    foreach ($item in $scalar)
    {
        $compositeName = "c$($item.Name)" #Get-Name -Name $item.Name
        $content.Microsoft365DSC.Add($item.Name,
            @{
                CompositeResourceName = $compositeName
                ParameterType         = 'Scalar'
            })
    }
    foreach ($item in $array)
    {
        $compositeName = "c$($item.Name)" #Get-Name -Name $item.Name
        $content.Microsoft365DSC.Add($item.Name,
            @{
                CompositeResourceName = $compositeName
                ParameterType         = 'Array'
            })
    }

    #$content.Microsoft365DSC | ft -Property Name, @{ Label = 'CompositeName'; Expression = { $_.Value.ParameterType } }

    $utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines("$sourcePath\DSCResources.yml", ($content | ConvertTo-Yaml), $utf8NoBomEncoding)

}
