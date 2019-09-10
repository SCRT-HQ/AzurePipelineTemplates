Param ($Task)

try {
    Write-Host "Executing task: $Task"
    Write-Host "`n`nPSVersionTable:"
    [PSCustomObject]$PSVersionTable
    Write-Host "GitVersion version:`n"
    'GitVersion ' + (gitversion /version)
    Write-Host "`n`nValidating Modules installed:`n"
    $Dependencies = . (Join-Path $PSScriptRoot 'moduleDependencies.ps1')
    $Dependencies.GetEnumerator() | ForEach-Object {
        $module = $_.Key
        $version = $_.Value
        Write-Host "Checking if module $($module)@$($version)+ is installed"
        if (($found = Get-Module $module -ListAvailable | Where-Object {$_.Version -ge [version]$version})) {
            Write-Host "$module found:";$found | Format-Table Name,Version | Out-Host
        }
        else {
            throw "$($module)@$($version)+ was not found on this container!"
            exit 1
        }
    }
}
catch {
    throw $_
    exit 1
}
