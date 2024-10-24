BeforeAll {
    Import-Module $PSScriptRoot\..\DHLog\DHLog -Force
}

Describe "Write-LogEntry" {
    BeforeAll {
        $DefaultLogPath = 'C:\temp\Logs'
        $DefaultLogFile = "PowerShell-$(Get-Date -Format yyyyMMdd).log"
        $DefaultFullLogPath = Join-Path $DefaultLogPath -ChildPath $DefaultLogFile
        $TestLogPath = "TestDrive:\Logs"
        $TestLogFile = "Test-123.log"
        $TestFullLogPath = Join-Path $TestLogPath -ChildPath $TestLogFile
        $Message = 'Test Message'
    }
    Context "Verify Parameters" {
        It "Should have parameter: 'LogPath'" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName LogMessage -Mandatory
        }
        It "Should have parameter: LogPath" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName LogPath -DefaultValue "C:\temp\Logs"
        }
        It "Should have parameter: LogFile" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName LogFile -DefaultValue 'PowerShell-$(Get-Date -Format yyyyMMdd).log'
        }
        It "Should have parameter: LogLevel" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName LogLevel -DefaultValue 'INFO'
        }
        It "Should have parameter: StartLog" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName StartLog -Type switch
        }
        It "Should have parameter: StopLog" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName StopLog -Type switch
        }
        It "Should have parameter: RotateLog" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName RotateLog -Type switch
        }
        It "Should have parameter: MaxLogSize" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName MaxLogSize -Type int
        }
        It "Should have parameter: ForceRotate" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName ForceRotate -Type switch
        }
        It "Should have parameter: Structured" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName Structured -Type switch
        }
        It "Should have parameter: Tee" {
            Get-Command Write-LogEntry | Should -HaveParameter -ParameterName Tee -Type switch
        }
    }
    Context 'Default Values' {
        BeforeEach {
            Mock -ModuleName DHLog -CommandName 'Test-Path'
            Mock -ModuleName DHLog -CommandName 'New-Item'
            Mock -ModuleName DHLog -CommandName 'Add-Content'
        }
        It "Test if the Full Log Path exists" {
            Write-LogEntry $Message | Should -Invoke -ModuleName DHLog -CommandName Test-Path -Times 1 -Exactly
        }
        It "Create the LogFile if it doesn't exist" {
            Write-LogEntry $Message | Should -Invoke -ModuleName DHLog -CommandName New-Item -Times 1 -Exactly
        }
        It "Don't create the LogFile if it exists" {
            Mock -ModuleName DHLog -CommandName 'Test-Path' { $true }
            Write-LogEntry $Message | Should -Invoke -ModuleName DHLog -CommandName New-Item -Times 0 -Exactly
        }
    }
    Context "Custom Log Path" {
        BeforeEach {
            Mock -ModuleName DHLog -CommandName 'Test-Path'
            Mock -ModuleName DHLog -CommandName 'New-Item'
            Mock -ModuleName DHLog -CommandName 'Add-Content'
        }
        It "Test if the Full Log Path exists" {
            Write-LogEntry $Message -LogPath "$TestLogPath" | Should -Invoke -ModuleName DHLog -CommandName Test-Path -Times 1 -Exactly
        }
        It "Create the LogFile if it doesn't exist" {
            Write-LogEntry $Message -LogPath "$TestLogPath" | Should -Invoke -ModuleName DHLog -CommandName New-Item -Times 1 -Exactly
        }
        It "Don't create the LogFile if it exists" {
            Mock -ModuleName DHLog -CommandName 'Test-Path' { $true }
            Write-LogEntry $Message -LogPath "$TestLogPath" | Should -Invoke -ModuleName DHLog -CommandName New-Item -Times 0 -Exactly
        }
    }
    Context "Verify Resources" {
        It "Log Path Exists" {
            Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile"
            Test-Path $TestFullLogPath | Should -Be $true
        }
        It "Log File Exists" {
            Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile"
            Test-Path $TestFullLogPath | Should -Be $true
        }
        It "Log Entry contains `$Message" {
            Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile"
            $TestFullLogPath | Should -FileContentMatch "$Message"
        }
    }
    Context "Verify Tee Output" {
        It "Display Message to the Information stream" {
            $result = Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile" -Tee 6>&1
            $result | Should -Match "$Message"
        }
    }
    Context "Verify LogLevel" {
        BeforeEach {
            Mock -ModuleName DHLog -CommandName Write-Verbose
            Mock -ModuleName DHLog -CommandName Write-Warning
            Mock -ModuleName DHLog -CommandName Write-Error
        }
        It "Log Entry contains LogLevel 'INFO'" {
            Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile" -LogLevel 'INFO'
            $TestFullLogPath | Should -FileContentMatchExactly "INFO"
        }
        It "Log Entry contains LogLevel 'WARN'" {
            Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile" -LogLevel 'WARN' | Should -Invoke -ModuleName DHLog -CommandName Write-Warning -Times 1 -Exactly
            $TestFullLogPath | Should -FileContentMatchExactly "WARN"
        }
        It "Log Entry contains LogLevel 'ERROR'" {
            Write-LogEntry $Message -LogPath "$TestLogPath" -LogFile "$TestLogFile" -LogLevel 'ERROR' | Should -Invoke -ModuleName DHLog -CommandName Write-Error -Times 1 -Exactly
            $TestFullLogPath | Should -FileContentMatchExactly "ERROR"
        }
    }
    Context "Start/Stop Log" {
        BeforeEach {
            Mock -ModuleName DHLog -CommandName 'Test-Path'
            Mock -ModuleName DHLog -CommandName 'New-Item'
            Mock -ModuleName DHLog -CommandName 'Add-Content'
        }
        It "StartLog parameter should test if Log Path exists" {
            Write-LogEntry -StartLog | Should -Invoke -ModuleName DHLog -CommandName Test-Path -Times 1 -Exactly
        }
        It "StopLog parameter should test if Log Path exists" {
            Write-LogEntry -StopLog | Should -Invoke -ModuleName DHLog -CommandName Test-Path -Times 1 -Exactly
        }
    }
}