

# Winget Scheduled Task Script

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
