$manifest = @{
    Path              = '.\DHLog\DHLog.psd1'
    RootModule        = 'DHLog.psm1' 
    Author            = 'Darren Hollinrake'
    Company           = 'Darren Hollinrake'
    Description       = 'Basic PowerShell Logging Module'
    ModuleVersion     = '1.1'
    GUID              = 'a66fb643-d3cf-45b6-8205-ba386bd44bcb'
    FunctionsToExport = @('Write-LogEntry')
}
New-ModuleManifest @manifest