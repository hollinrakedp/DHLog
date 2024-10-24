function Invoke-RotateLogFile {
    <#
    .SYNOPSIS
    Rotates a log file based on size or force rotation.

    .NOTES
    Name       : Invoke-RotateLogFile
    Author     : Darren Hollinrake
    Version    : 1.0.0
    DateCreated: 2024-10-22
    DateUpdated: 

    .DESCRIPTION
    This function rotates a log file either when it exceeds a specified size or when forced. The rotated log file is renamed with a timestamp appended to its original name.

    .PARAMETER LogPath
    The path to the log file that needs to be rotated. This parameter is mandatory.

    .PARAMETER MaxLogSize
    The maximum size of the log file in megabytes before it is rotated. This parameter is only applicable in the 'SizeRotate' parameter set and defaults to 1 MB.

    .PARAMETER Force
    Forces the rotation of the log file irrespective of its size. This parameter is only applicable in the 'ForceRotate' parameter set.

    .EXAMPLE
    Invoke-RotateLogFile -LogPath "C:\Logs\mylog.log" -MaxLogSize 5

    Rotates the log file if it exceeds 5 MB in size.

    .EXAMPLE
    Invoke-RotateLogFile -LogPath "C:\Logs\mylog.log" -Force

    Forces the rotation of the log file irrespective of its size.

    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'SizeRotate')]
    param (
        [Parameter(ParameterSetName = 'SizeRotate', Mandatory = $true)]
        [Parameter(ParameterSetName = 'ForceRotate', Mandatory = $true)]
        [string]$LogPath,

        [Parameter(ParameterSetName = 'SizeRotate')]
        [int]$MaxLogSize = 1,

        [Parameter(ParameterSetName = 'ForceRotate')]
        [switch]$Force
    )

    if (Test-Path $LogPath) {
        $LogFileSize = (Get-Item $LogPath).Length
        $MaxSizeBytes = $MaxLogSize * 1MB

        if ($Force -or $LogFileSize -gt $MaxSizeBytes) {
            $Timestamp = Get-Date -Format "yyyyMMddHHmmssfff"
            $NewLogPath = "$LogPath.$Timestamp"
            Rename-Item -Path $LogPath -NewName $NewLogPath -WhatIf:$WhatIfPreference
        }
    }
    else {
        Write-Warning "Log file '$LogPath' does not exist and could not be rotated."
    }
}