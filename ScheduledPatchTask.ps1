# Check if Get-WindowsUpdate cmdlet is available
$windowsUpdateModule = Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue
if ($windowsUpdateModule -eq $null) {
    Write-Host "Get-WindowsUpdate cmdlet is not available."

    # Check for internet connectivity
    $internetAvailable = Test-Connection -Count 1 -ErrorAction SilentlyContinue
    if ($internetAvailable) {

        # Install Windows Update module
        Install-Module PSWindowsUpdate -Force 
        Import-Module PSWindowsUpdate

        Write-Host "Windows Update module installed."
    } else {
        Write-Host "Internet is not available. Cannot install Windows Update module."
        Exit
    }
}

# Define the script content with logging
$scriptContent = @"
# Define the log file path
`$logFilePath = "C:\Program Files\Script\WindowsUpdateTask.log"

# Log the current timestamp and a message
function Write-Log {
    param([string]`$message)
    `$logEntry = "`$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - `$message"
    `$logEntry | Out-File -Append -FilePath `$logFilePath
}

Write-Log "Script started."
Start-Sleep -Seconds 30
# Check if Get-WindowsUpdate cmdlet is available
`$windowsUpdateModule = Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue
if (`$windowsUpdateModule -eq `$null) {
    Write-Log "Get-WindowsUpdate cmdlet is not available."

    # Check for internet connectivity
    `$internetAvailable = Test-Connection -Count 1 -ErrorAction SilentlyContinue
    if (`$internetAvailable) {
        Write-Log "Internet is available. Attempting to install Windows Update module."
        
        # Install Windows Update module
        try {
            Install-Module PSWindowsUpdate -Force -ErrorAction Stop
            Import-Module PSWindowsUpdate
            Write-Log "Windows Update module installed."
        } catch {
            Write-Log "Failed to install Windows Update module: `$_"
            Exit
        }
    } else {
        Write-Log "Internet is not available. Cannot install Windows Update module."
        Exit
    }
}

# Rest of your script to perform Windows updates
Write-Log "Starting the Windows Update command."

# Run the Windows Update command
try {
    Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot -Silent
    Write-Log "Windows updates command run successfully."
} catch {
    Write-Log "Windows updates encountered an error: `$_"
}

Write-Log "Script finished."

"@


# Specify the path to save the script
$scriptPath = "C:\Program Files\Script\WindowsUpdateTask.ps1"

# Check if the script file already exists
if (-not (Test-Path -Path $scriptPath)) {
    # If the file doesn't exist, create it and set the content
    $scriptContent | Set-Content -Path $scriptPath
    Write-Host "Script file created at: $scriptPath"
} else {
    Write-Host "Script file already exists at: $scriptPath"
}

# Check if the scheduled task already exists
$taskName = "WindowsUpdateTask"
if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
    # If the task doesn't exist, create it
    $taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

    $initialTrigger = New-ScheduledTaskTrigger -AtLogOn

    $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd 
   

    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

    Register-ScheduledTask -Action $taskAction -Trigger $initialTrigger -TaskName $taskName -Settings $taskSettings -Principal $principal
    Write-Host "Scheduled task created: $taskName"
} else {
    Write-Host "Scheduled task already exists: $taskName"
}
