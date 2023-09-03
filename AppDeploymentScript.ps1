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


$successfulInstallations = @()
$alreadyInstalled = @()
$failedInstallations = @()

# Define an array of applications with their details
$applications = @(
    @{Id="Microsoft.WindowsTerminal"; Name="Windows Terminal"},
    @{Id="PuTTY.PuTTY"; Name="PuTTY"},
    @{Id="Notepad++.Notepad++"; Name="Notepad++"},
    @{Id="Spotify.Spotify"; Name="Spotify"},
    @{Id="EpicGames.EpicGamesLauncher"; Name="Epic Games Launcher"},
    @{Id="Brave.Brave"; Name="Brave"},
    @{Id="Greenshot.Greenshot"; Name="Greenshot"},
    @{Id="TeamViewer.TeamViewer"; Name="TeamViewer"},
    @{Id="7zip.7zip"; Name="7-Zip"},
    @{Id="Google.GoogleDrive"; Name="Google Drive"},
    @{Id="CodecGuide.K-LiteCodecPack.Basic"; Name="K-Lite Codec Pack Basic"},
    @{Id="qBittorrent.qBittorrent"; Name="qBittorrent"},
    @{Id="Python.Python.3.12"; Name="Python 3.12"},
    @{Id="Microsoft.VisualStudioCode"; Name="Visual Studio Code"},
    @{Id="ProtonTechnologies.ProtonVPN"; Name="ProtonVPN"},
    @{Id="Telegram.TelegramDesktop"; Name="Telegram Desktop"},
    @{Id="Microsoft.PowerToys"; Name="PowerToys"},
    @{Id="Canonical.Ubuntu.2204"; Name="Ubuntu 20.04"},
    @{Id="Ghisler.TotalCommander"; Name="Total Commander"}
)

foreach ($app in $applications) {
    $appId = $app.Id
    $appName = $app.Name

    # Escape special characters in the application ID for regex pattern
    $escapedAppId = [regex]::Escape($appId)

    # Check if the application is already installed
    $isInstalled = (winget list | Select-String -Pattern $escapedAppId)

    if ($isInstalled) {
        Write-Host "$appName is already installed."
        $alreadyInstalled += $appName
    } else {
        # Install the application
        Write-Host "Installing $appName..."
        $installResult = winget install --id=$appId -e --accept-source-agreements --accept-package-agreements

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$appName installed successfully."
            $successfulInstallations += $appName
        } else {
            Write-Host "Failed to install $appName. ExitCode: $LASTEXITCODE" -ForegroundColor Red
            
            $failedInstallations += $appName
        }
    }
}

# Display summaries
Write-Host "Installation summary:"
Write-Host "Successful installations: $($successfulInstallations -join ', ')" -ForegroundColor Green
Write-Host "Already installed: $($alreadyInstalled -join ', ')" -ForegroundColor Yellow
Write-Host "Failed installations: $($failedInstallations -join ', ')" -ForegroundColor Red

# End of script
