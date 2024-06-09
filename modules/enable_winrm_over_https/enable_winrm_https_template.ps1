# enable_winrm_https_template.ps1

param (
    [string]$PrivateIp,
    [string]$PublicIp
)

try {
    # Set Execution Policy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
    
    # Enable PS Remoting
    Enable-PSRemoting -Force
    
    # Configure WinRM for HTTP
    winrm quickconfig -q
    winrm set winrm/config/service @{AllowUnencrypted = "true" }
    winrm set winrm/config/service/auth @{Basic = "true" }
    winrm set winrm/config/client/auth @{Basic = "true" }
    
    # Create a self-signed certificate for HTTPS for the private IP
    $certPrivate = New-SelfSignedCertificate -DnsName $PrivateIp -CertStoreLocation Cert:\LocalMachine\My
    
    # Configure HTTPS listener for the private IP
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname = $PrivateIp; CertificateThumbprint = "$($certPrivate.Thumbprint)" }

    if ($PublicIp) {
        # Create a self-signed certificate for HTTPS for the public IP
        $certPublic = New-SelfSignedCertificate -DnsName $PublicIp -CertStoreLocation Cert:\LocalMachine\My
        
        # Configure HTTPS listener for the public IP
        winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname = $PublicIp; CertificateThumbprint = "$($certPublic.Thumbprint)" }
    }

    # Open the firewall for WinRM
    netsh advfirewall firewall set rule group="windows remote management" new enable=yes
    
    # Log success
    "WinRM HTTPS enabled successfully" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    exit 0
}
catch {
    # Log errors
    "Error occurred: $_" | Out-File -FilePath "C:\\enable_winrm_https.log" -Append
    exit 1
}
