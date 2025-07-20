# Enable script execution policy for the current user
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# Optional: Confirm the policy was set
Get-ExecutionPolicy -List
