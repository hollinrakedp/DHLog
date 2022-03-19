$ModuleName = $PSScriptRoot | Split-Path -Leaf
$FunctionsToExport = @( (Get-ChildItem -Path $PSScriptRoot\$ModuleName\Public\*.ps1).BaseName )

$manifest = @{
    Path              = "$PSScriptRoot\$ModuleName\$ModuleName.psd1"
    RootModule        = "$ModuleName.psm1"
    Author            = 'Darren Hollinrake'
    Company           = 'Darren Hollinrake'
    Description       = 'Basic PowerShell Logging Module'
    ModuleVersion     = '1.1'
    FunctionsToExport = $FunctionsToExport
}

if (Test-Path $manifest.Path){
    Update-ModuleManifest @manifest
}
else {
    New-ModuleManifest @manifest
}