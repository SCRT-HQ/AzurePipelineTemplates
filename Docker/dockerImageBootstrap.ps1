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
$Dependencies = . (Join-Path $PSScriptRoot 'moduleDependencies.ps1')
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
