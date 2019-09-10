Param ($Task)

try {
    Write-Host "Executing task: $Task`n`nModules installed:"
    Get-Module -ListAvailable
    Write-Host "`n`nPSVersionTable:"
    [PSCustomObject]$PSVersionTable
    Write-Host "GitVersion version:`n"
    'GitVersion ' + (gitversion /version)
}
catch {
    throw $_
    exit 1
}
