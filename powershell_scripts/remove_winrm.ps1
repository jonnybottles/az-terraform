$hostname = $env:computername

# Check if the WinRM service is running
$isRunningService = (Get-Service winrm).Status -eq "Running"

# Remove all WinRM listeners
Write-Output "Removing all WinRM listeners..."
try {
    winrm delete winrm/config/Listener?Address=*+Transport=HTTP
    Write-Output "Removed HTTP listener"
}
catch {
    Write-Output "No HTTP listener to remove or error removing HTTP listener: $_"
}

try {
    winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
    Write-Output "Removed HTTPS listener"
}
catch {
    Write-Output "No HTTPS listener to remove or error removing HTTPS listener: $_"
}

# Verify if the listeners were removed
Write-Output "Remaining WinRM listeners:"
winrm enumerate winrm/config/listener

# Remove the self-signed SSL certificate
Write-Output "Removing self-signed SSL certificate..."
$certificates = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.DnsNameList -contains $hostname }
foreach ($cert in $certificates) {
    Write-Output "Removing certificate: $($cert.Thumbprint)"
    Remove-Item -Path "Cert:\LocalMachine\My\$($cert.Thumbprint)" -Force
}

# Remove the firewall rule
Write-Output "Removing firewall rule..."
netsh advfirewall firewall delete rule name="Windows Remote Management (HTTPS-In)"

# Stop the WinRM service if it was started by the script
if (-not ($isRunningService)) {
    Write-Output "Stopping WinRM service..."
    Stop-Service winrm
}

Write-Output "Reversal complete."
