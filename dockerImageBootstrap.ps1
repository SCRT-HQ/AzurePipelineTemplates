Write-Host -ForegroundColor Cyan "Setting PSGallery to Trusted"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose:$false

Write-Host -ForegroundColor Cyan "Bootstrapping NuGet"
$null = Get-PackageProvider -Name NuGet -ForceBootstrap -Verbose:$false
$PSDefaultParameterValues = @{
    '*-Module:Verbose'                  = $false
    '*-Module:Force'                    = $true
    'Import-Module:ErrorAction'         = 'Stop'
    'Install-Module:AcceptLicense'      = $true
    'Install-Module:AllowClobber'       = $true
    'Install-Module:Confirm'            = $false
    'Install-Module:ErrorAction'        = 'Stop'
    'Install-Module:Repository'         = 'PSGallery'
    'Install-Module:SkipPublisherCheck' = $true
}
$Dependencies = @{
    Configuration     = '1.3.1'
    PackageManagement = '1.3.1'
    PowerShellGet     = '2.1.2'
    InvokeBuild       = '5.5.2'
    psake             = '4.8.0'
    Pester            = '4.9.0'
    PSScriptAnalyzer  = '1.18.2'
}
$moduleDependencies = @()
foreach ($module in $Dependencies.Keys) {
    $moduleDependencies += @{
        Name           = $module
        MinimumVersion = $Dependencies[$module]
        Force          = $true
    }
}
foreach ($item in $moduleDependencies) {
    if (Get-Module "$($item['Name'])*" -ListAvailable | Where-Object {
        $_.Name -eq $item['Name'] -and
        $_.Version -ge [Version]$item['MinimumVersion']
    }) {
        Write-Host -ForegroundColor Cyan "[$($item['Name'])] Module already installed -- skipping"
    }
    else {
        Install-Module @item
    }
}

if (-not (Test-Path $profile.AllUsersAllHosts)) {
    New-Item $profile.AllUsersAllHosts
}
@'
function global:gitversion {
    mono /GitVersion/GitVersion.exe $args
}
'@ | Set-Content $profile.AllUsersAllHosts
