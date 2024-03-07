# Check if OpenSSH Server is already installed
$sshServerCapability = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
if ($sshServerCapability.State -eq 'Installed') {
    Write-Output "OpenSSH Server is already installed."
} else {
    # Install OpenSSH Server
    Write-Output "Installing OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

# Start the sshd service
Write-Output "Starting sshd service..."
Start-Service sshd

# Set sshd service to start automatically
Write-Output "Setting sshd service to start automatically..."
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured, if not, create it
$firewallRule = Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue
if (-not $firewallRule) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' already exists."
}
