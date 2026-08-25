@{
    PSDependOptions             = @{
        AddToPath  = $true
        Target     = 'output\RequiredModules'
        Parameters = @{
            Repository      = 'PSGallery'
            AllowPreRelease = $true
        }
    }

    Microsoft365DSC             = '1.26.819.1'

    InvokeBuild                 = 'latest'
    PSScriptAnalyzer            = 'latest'
    Pester                      = '5.9.1'
    Plaster                     = 'latest'
    ModuleBuilder               = 'latest'
    ChangelogManagement         = 'latest'
    Sampler                     = 'latest'
    'Sampler.GitHubTasks'       = 'latest'
    Datum                       = 'latest'
    'Datum.ProtectedData'       = 'latest'
    ProtectedData               = 'latest'
    DscBuildHelpers             = 'latest'
    'DscResource.Test'          = 'latest'
    MarkdownLinkCheck           = 'latest'
    'DscResource.AnalyzerRules' = 'latest'
    'DscResource.DocGenerator'  = 'latest'
    PSDesiredStateConfiguration = 'latest'
    xDscResourceDesigner        = 'latest'

}
