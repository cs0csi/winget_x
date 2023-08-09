# Winget Scheduled Task Script (Create-WingetScheduledTask.ps1)

This PowerShell script creates a scheduled task to run the `winget upgrade --all` command at user logon. The task will execute the command to upgrade all installed packages using Winget.

## Prerequisites

1. Internet Connectivity: The script checks for internet connectivity by attempting to ping google.com.

2. Winget Installation: The script checks if Winget is already installed. If not, it provides an option to install it using the Microsoft Desktop App Installer.

## Usage

1. Clone or download this repository to your local machine.

2. Open PowerShell with administrative privileges.

3. Navigate to the directory where the script is located.

4. Run the script using the following command:

   ```powershell
   .\Create-WingetScheduledTask.ps1
   ```

5. Follow the on-screen prompts to install Winget if needed and create the scheduled task.

## Note

- This script creates a scheduled task that runs at user logon and executes the `winget upgrade --all` command.

- The script checks for prerequisites (internet connectivity and Winget installation) before creating the scheduled task.

- Use this script responsibly and ensure you understand the commands being executed.




# App Deployment PowerShell Script (AppDeploymentScript.ps1)

```markdown
This PowerShell script automates the installation of a list of applications using Windows Package Manager (`winget`). It performs pre-installation checks, installs the specified applications, and provides a summary of successful, already installed, and failed installations.

## Prerequisites

- PowerShell 5.1 or later (Pre-installed on most Windows systems)
- Active internet connection

## Usage

1. Open PowerShell on your Windows machine.

2. Run the script using the following command:

   ```powershell
   .\AppDeploymentScript.ps1
   ```

3. The script will perform the following tasks:
   - Check for an active internet connection.
   - Check if `winget` is installed. If not, it will prompt to install it.
   - Install the specified applications if they are not already installed.
   - Display a summary of the installation process.

4. The summary will include:
   - Successful installations (in green).
   - Already installed applications (in yellow).
   - Failed installations with exit codes (in red).

## Configuration

Edit the script to customize the list of applications you want to install. Locate the `$applications` array and add or remove application entries as needed. Each application entry should have an `Id` (the `winget` application ID) and a `Name`.

## Disclaimer

Please use this script responsibly and make sure to review and understand the script's functionality before running it. The script performs installations and may modify your system. The author is not responsible for any unintended consequences.
