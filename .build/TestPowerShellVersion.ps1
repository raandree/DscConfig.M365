task TestPowerShell5 {
    if ($PSVersionTable.PSEdition -ne 'Desktop')
    {
        Write-Error 'The build script required PowerShell 7+ to work'
    }
}

task TestPowerShell7 {
    if ($PSVersionTable.PSEdition -ne 'Core')
    {
        Write-Error 'The build script required PowerShell 7+ to work'
    }
}
