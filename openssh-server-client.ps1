
#Author: Arnold Vianna
#Requires -RunAsAdministrator

# Check for compatibility
if (!(Get-Command Add-WindowsCapability -ErrorAction SilentlyContinue)) {
    Write-Error "This script requires Windows 10 version 1809 or later, or Windows Server 2019 or later."
    exit 1
}

# Install SSH Client
try {
    Add-WindowsCapability -Online -Name OpenSSH.Client*
    Write-Host "✔️ Installed SSH client"
}
catch {
    Write-Error "⚠️ Error installing SSH client: $($_.Exception.Message)"
    exit 1
}

# Install SSH Server
try {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'

    # Ensure firewall rule is enabled
    Get-NetFirewallRule -Name *ssh* | Where-Object { $_.Enabled -eq $false } | Set-NetFirewallRule -Enabled True

    Write-Host "✔️ Installed and started SSH server"
}
catch {
    Write-Error "⚠️ Error installing SSH server: $($_.Exception.Message)"
    exit 1
}
