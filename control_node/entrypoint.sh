#!/bin/bash

# Configure TrustedHosts for PowerShell remoting
pwsh -Command "Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*' -Force"

# Start SSH service
/usr/sbin/sshd -D
service ssh start

# Keep the container running
tail -f /dev/null
