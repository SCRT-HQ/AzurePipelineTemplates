Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose:$false
$null = Get-PackageProvider -Name Nuget -ForceBootstrap -Verbose:$false
$PSDefaultParameterValues = @{
    '*-Module:Verbose'                  = $false
    '*-Module:Force'                    = $true
    'Import-Module:ErrorAction'         = 'Stop'
    'Install-Module:AcceptLicense'      = $true
    'Install-Module:AllowClobber'       = $true
    'Install-Module:Confirm'            = $false
    'Install-Module:ErrorAction'        = 'Stop'
    'Install-Module:Repository'         = 'PSGallery'
    'Install-Module:Scope'              = 'CurrentUser'
    'Install-Module:SkipPublisherCheck' = $true
}
$Dependencies = @{
    Configuration     = '1.3.1'
    PackageManagement = '1.3.1'
    PowerShellGet     = '2.1.2'
    InvokeBuild       = '5.5.2'
    psake             = '4.8.0'
    Pester            = '4.9.0'
}
$moduleDependencies = @()
foreach ($module in $Dependencies.Keys) {
    $moduleDependencies += @{
        Name           = $module
        MinimumVersion = $Dependencies[$module]
    }
}
foreach ($item in $moduleDependencies) {
    Write-BuildLog "[$($item['Name'])] Resolving"
    try {
        if ($imported = Get-Module $item['Name']) {
            Write-BuildLog "[$($item['Name'])] Removing imported module"
            $imported | Remove-Module
        }
        Import-Module @item
    }
    catch {
        Write-BuildLog "[$($item['Name'])] Installing missing module"
        Install-Module @item
        Import-Module @item
    }
}
