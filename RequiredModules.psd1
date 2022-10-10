@{
    PSDependOptions                                   = @{
        AddToPath  = $true
        Target     = 'output\RequiredModules'
        Parameters = @{
            Repository      = 'PSGallery'
            AllowPreRelease = $true
        }
    }

    InvokeBuild                                       = 'latest'
    PSScriptAnalyzer                                  = 'latest'
    Pester                                            = 'latest'
    Plaster                                           = 'latest'
    ModuleBuilder                                     = 'latest'
    ChangelogManagement                               = 'latest'
    Sampler                                           = 'latest'
    'Sampler.GitHubTasks'                             = 'latest'
    Datum                                             = 'latest'
    'Datum.ProtectedData'                             = 'latest'
    DscBuildHelpers                                   = 'latest'
    'DscResource.Test'                                = 'latest'
    MarkdownLinkCheck                                 = 'latest'
    'DscResource.AnalyzerRules'                       = 'latest'
    'DscResource.DocGenerator'                        = 'latest'

    #DSC Resources
    'Microsoft365DSC'                                 = '1.22.1005.1'

    'Microsoft.Graph.Applications'                    = '1.9.5'
    'Microsoft.Graph.Authentication'                  = '1.9.5'
    'Microsoft.Graph.Groups'                          = '1.9.5'
    'Microsoft.Graph.Users'                           = '1.9.5'
    'Microsoft.Graph.DeviceManagement'                = '1.9.5'
    'Microsoft.Graph.DeviceManagement.Administration' = '1.9.5'
    'Microsoft.Graph.DeviceManagement.Enrolment'      = '1.9.5'
    'Microsoft.Graph.Devices.CorporateManagement'     = '1.9.5'
    'Microsoft.Graph.Identity.DirectoryManagement'    = '1.9.5'
    'Microsoft.Graph.Identity.Governance'             = '1.9.5'
    'Microsoft.Graph.Identity.SignIns'                = '1.9.5'
    'Microsoft.Graph.Planner'                         = '1.9.5'
    'Microsoft.Graph.Teams'                           = '1.9.5'
    'Microsoft.PowerApps.Administration.PowerShell'   = '2.0.145'
    'MicrosoftTeams'                                  = '4.2.0'
    'MSCloudLoginAssistant'                           = '1.0.83'
    'PnP.PowerShell'                                  = '1.10.0'

}
