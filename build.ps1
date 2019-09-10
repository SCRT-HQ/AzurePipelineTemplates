Param ($Task)

try {
    Write-Host "Executing task: $Task"
    Write-Host "`n`nPSVersionTable:"
    [PSCustomObject]$PSVersionTable
    Write-Host "GitVersion version:`n"
    'GitVersion ' + (gitversion /version)
    Write-Host "`n`nValidating Modules installed:"
    @{
        Configuration     = '1.3.1'
        PackageManagement = '1.3.1'
        PowerShellGet     = '2.1.2'
        InvokeBuild       = '5.5.2'
        psake             = '4.8.0'
        Pester            = '4.9.0'
        PSScriptAnalyzer  = '1.18.2'
    }.GetEnumerator() | ForEach-Object {
        $module = $_.Key
        $version = $_.Value
        Write-Host "Checking if module $($module)@$($version)+ is installed"
        if ($null -eq (Get-Module $_.Key -ListAvailable | Where-Object {$_.Version -ge [version]$version})) {
            throw "$($module)@$($version)+ was not found on this container!"
            exit 1
        }
    }
}
catch {
    throw $_
    exit 1
}
