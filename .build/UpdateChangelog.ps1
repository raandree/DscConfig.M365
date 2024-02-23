task UpdateChangelog {

    $m365DscModule = Get-Module -Name Microsoft365DSC -ListAvailable

    $changeLogContent = [System.Collections.ArrayList](Get-Content -Path D:\git\DscConfig.M365\CHANGELOG.md)

    $unreleasedLine = $changeLogContent | Select-String -Pattern '## \[Unreleased\]'
    $lastReleaseLine = $changeLogContent | Select-String -Pattern '## \[\d{0,3}\.\d{0,3}\.\d{0,3}\] - \d{4}-\d{2}-\d{2}' | Select-Object -First 1

    $currentUpdateLine = "- Updated Microsoft365DSC to version $($m365DscModule.Version)."

    #$changeLogContent[($unreleasedLine.LineNumber + 1)..($lastReleaseLine.LineNumber - 1)] | Where-Object { $_ -like "$currentUpdateLine*" }

    #$pattern = "(- Updated Microsoft365DSC to version $([System.Text.RegularExpressions.Regex]::Escape($m365DscModule.Version)) ?)((?<Iterations>\(\d{1,3}\))?(\.)?"
    $pattern = "(- Updated Microsoft365DSC to version $([System.Text.RegularExpressions.Regex]::Escape($m365DscModule.Version)) ?\()(?<Iterations>\d{1,3})(\)?(\.)?)"

    if ($changeLogContent[($unreleasedLine.LineNumber + 1)..($lastReleaseLine.LineNumber - 1)] -match $pattern)
    {
        if (-not $Matches.Iterations)
        {
            $currentUpdateLine = $currentUpdateLine.Substring(0, $currentUpdateLine.Length -2) + " (1)."
        }
        else
        {
            $currentUpdateLine = "- Updated Microsoft365DSC to version $($m365DscModule.Version) ($($Matches.Iterations))."
        }

    }

    $changeLogContent.Insert($unreleasedLine.LineNumber, $currentUpdateLine)

    $changeLogContent | Set-Content -Path $ProjectPath\CHANGELOG.md

}
