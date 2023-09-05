@{
    PSDependOptions                                        = @{
        AddToPath  = $true
        Target     = 'output\RequiredModules'
        Parameters = @{
            Repository      = 'PSGallery'
            AllowPreRelease = $true
        }
    }

    'Microsoft365DSC'                                      = '1.23.830.1'

    InvokeBuild                                            = 'latest'
    PSScriptAnalyzer                                       = 'latest'
    Pester                                                 = 'latest'
    Plaster                                                = 'latest'
    ModuleBuilder                                          = 'latest'
    ChangelogManagement                                    = 'latest'
    Sampler                                                = 'latest'
    'Sampler.GitHubTasks'                                  = 'latest'
    Datum                                                  = 'latest'
    'Datum.ProtectedData'                                  = 'latest'
    DscBuildHelpers                                        = 'latest'
    'DscResource.Test'                                     = 'latest'
    MarkdownLinkCheck                                      = 'latest'
    'DscResource.AnalyzerRules'                            = 'latest'
    'DscResource.DocGenerator'                             = 'latest'

}
