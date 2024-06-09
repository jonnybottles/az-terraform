param (
    [string]$PrivateIp,
    [string]$PublicIp
)

try {
    # Set Execution Policy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

    # Ensure WinRM service is running
    $isRunningService = (Get-Service winrm).Status -eq "Running"
    if (-not $isRunningService) {
        Write-Output "Starting WinRM service..."
        Start-Service winrm
    }

    # Configure WinRM service
    Write-Output "Configuring WinRM service..."
    winrm set winrm/config/service/auth '@{Basic="true"}'
    winrm set winrm/config/client/auth '@{Basic="true"}'
    "Configured WinRM service to support Basic authentication." | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

    # Remove existing HTTPS listeners
    Write-Output "Removing existing HTTPS listeners..."
    $existingListeners = winrm enumerate winrm/config/listener | Select-String -Pattern "Transport=HTTPS"
    foreach ($listener in $existingListeners) {
        if ($listener -match "Address=([^\s]+)\s+Transport=([^\s]+)") {
            $address = $matches[1]
            $transport = $matches[2]
            $listenerId = "Address=$address+Transport=$transport"
            Write-Output "Removing listener: $listenerId"
            winrm delete "winrm/config/listener?$listenerId"
        }
    }

    # Remove existing HTTP listeners
    Write-Output "Removing existing HTTP listeners..."
    $existingHttpListeners = winrm enumerate winrm/config/listener | Select-String -Pattern "Transport=HTTP"
    foreach ($listener in $existingHttpListeners) {
        if ($listener -match "Address=([^\s]+)\s+Transport=([^\s]+)") {
            $address = $matches[1]
            $transport = $matches[2]
            $listenerId = "Address=$address+Transport=$transport"
            Write-Output "Removing listener: $listenerId"
            winrm delete "winrm/config/listener?$listenerId"
        }
    }

    # Log listener removal success
    "Removed existing HTTP and HTTPS listeners." | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

    # Create a self-signed certificate for HTTPS for the private IP
    if ($PrivateIp) {
        $certPrivate = New-SelfSignedCertificate -DnsName $PrivateIp -CertStoreLocation Cert:\LocalMachine\My
        "Created self-signed certificate for Private IP: $PrivateIp" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

        # Export the certificate to a .cer file
        $certPathPrivate = "C:\\$PrivateIp.cer"
        Export-Certificate -Cert $certPrivate -FilePath $certPathPrivate
        "Exported certificate for Private IP to $certPathPrivate" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

        # Configure HTTPS listener for the private IP
        $listenerConfigPrivate = "@{Hostname=`"$PrivateIp`"; CertificateThumbprint=`"$($certPrivate.Thumbprint)`"}"
        Start-Process -FilePath "winrm" -ArgumentList "create winrm/config/Listener?Address=*+Transport=HTTPS $listenerConfigPrivate"
        "Configured HTTPS listener for Private IP: $PrivateIp" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    }

    if ($PublicIp) {
        # Create a self-signed certificate for HTTPS for the public IP
        $certPublic = New-SelfSignedCertificate -DnsName $PublicIp -CertStoreLocation Cert:\LocalMachine\My
        "Created self-signed certificate for Public IP: $PublicIp" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

        # Export the certificate to a .cer file
        $certPathPublic = "C:\\$PublicIp.cer"
        Export-Certificate -Cert $certPublic -FilePath $certPathPublic
        "Exported certificate for Public IP to $certPathPublic" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

        # Configure HTTPS listener for the public IP
        $listenerConfigPublic = "@{Hostname=`"$PublicIp`"; CertificateThumbprint=`"$($certPublic.Thumbprint)`"}"
        Start-Process -FilePath "winrm" -ArgumentList "create winrm/config/Listener?Address=*+Transport=HTTPS $listenerConfigPublic"
        "Configured HTTPS listener for Public IP: $PublicIp" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    }

    # Open the firewall for WinRM HTTPS
    Write-Output "Updating firewall..."
    netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
    "Firewall rules updated for WinRM." | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

    # Configure SSH for PowerShell Remoting
    Write-Output "Configuring SSH for PowerShell Remoting..."

    # Install OpenSSH Server if not already installed
    $isInstalled = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    if ($isInstalled.State -ne 'Installed') {
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        Write-Output "Installed OpenSSH Server." | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    }

    # Start SSH service
    $isRunningSSH = (Get-Service sshd).Status -eq "Running"
    if (-not $isRunningSSH) {
        Write-Output "Starting SSH service..."
        Start-Service sshd
        Set-Service -Name sshd -StartupType 'Automatic'
    }

    # Open firewall for SSH
    netsh advfirewall firewall add rule name="OpenSSH Server (sshd)" dir=in action=allow protocol=TCP localport=22
    "Firewall rules updated for SSH." | Out-File -FilePath "C:\\enable_winrm_https.log" -Append

    # Verify SSH PowerShell remoting configuration
    if (Test-Path -Path "C:\ProgramData\ssh\sshd_config") {
        $sshdConfig = Get-Content -Path "C:\ProgramData\ssh\sshd_config"
        $newSshdConfig = @()

        foreach ($line in $sshdConfig) {
            if ($line -notmatch "Subsystem powershell C:\\Program Files\\PowerShell\\7\\pwsh.exe -sshs -NoLogo -NoProfile") {
                $newSshdConfig += $line
            }
        }

        $newSshdConfig = "Subsystem powershell C:\Program Files\PowerShell\7\pwsh.exe -sshs -NoLogo -NoProfile" + "`n" + $newSshdConfig -join "`n"
        $newSshdConfig | Set-Content -Path "C:\ProgramData\ssh\sshd_config"

        Restart-Service sshd
        Write-Output "Configured SSH for PowerShell Remoting." | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    }

    # Log success
    "WinRM HTTPS and SSH enabled successfully" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    exit 0
}
catch {
    # Log errors
    "Error occurred: $_" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    exit 1
}
