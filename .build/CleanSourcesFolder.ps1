task Clean_Sources_Folder {

    if (Test-Path -Path $SourcePath\DSCResources)
    {
        Remove-Item -Path $SourcePath\DSCResources -Recurse -Force
    }

    if (Test-Path -Path $SourcePath\DSCResources.yml)
    {
        Remove-Item -Path $SourcePath\DSCResources.yml -Force -ErrorAction SilentlyContinue
    }

}