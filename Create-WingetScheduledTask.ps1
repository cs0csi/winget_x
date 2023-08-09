$taskName = "winget"
$actionProgram = "C:\Windows\System32\cmd.exe"
$actionArguments = "/c winget upgrade --all"

# Check if the task already exists and delete it if it does
Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

# Prerequisite: Check if there's internet connectivity
$pingResult = Test-Connection -ComputerName google.com -Count 1 -ErrorAction SilentlyContinue
if ($pingResult -eq $null) {
    Write-Host "Internet is not available. Exiting script."
    Exit
}

# Prerequisite: Check if Winget is installed or prompt to install
$wingetPath = Get-Command winget.exe -ErrorAction SilentlyContinue
if ($wingetPath -eq $null) {
    $installChoice = Read-Host "Winget is not installed. Do you want to install it? (yes/no)"
    
    if ($installChoice -eq "yes") {        
        $progressPreference = 'silentlyContinue'
        Write-Host "Downloading Winget and its dependencies..."
        Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
        Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
        Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
        Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
        Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        
        # Verify Winget installation
        $wingetPath = Get-Command winget.exe -ErrorAction SilentlyContinue
        if ($wingetPath -eq $null) {
            Write-Host "Failed to install Winget. Exiting script."
            Exit
        }
        
        Write-Host "Winget has been successfully installed."
    }
    else {
        Write-Host "Winget is not installed. Exiting script."
        Exit
    }
}
# Define the new scheduled task
$action = New-ScheduledTaskAction -Execute $actionProgram -Argument $actionArguments
$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd 
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$description = "Scheduled task to run winget upgrade --all at startup."

# Create the scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description $description

Write-Host "Scheduled task '$taskName' has been created."
