#!/usr/bin/env pwsh

#Locate and decrypt operator secret
$encryptedFilePath = "usr/local/bin/path_to_your_secret.gpg"
$pw = $(gpg --quiet --batch --yes --passphrase "your_passphrase" --decrypt $encryptedFilePath)

# Define the vCenter server and credentials
$vcenterServer = "10.X.X.X"
$username = "vCenterUsername"
$password = $pw
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# Connect to the vCenter server
Connect-VIServer -Server $vcenterServer -Credential $credential -Force

# Define the ESXi hosts
$esxiHosts = @("10.X.X.X")

# Define the NUT server VM name
$nutServerVM = "your_nutserver_hostname"

# Function to shut down a single ESXi host
function Shutdown-EsxiHost {
    param (
        [string]$esxiHost
    )

    try {
        # Get all running VMs on the host, excluding the NUT server VM
        $vms = Get-VM -Location (Get-VMHost -Name $esxiHost) | Where-Object { $_.PowerState -eq "PoweredOn" -and $_.Name -ne $nutServerVM }

        # Shut down all running VMs
        foreach ($vm in $vms) {
            Shutdown-VMGuest -VM $vm -Confirm:$false
            Write-Output "Shutting down VM: $($vm.Name)"
            Start-Sleep -Seconds 30  # Wait for 30 seconds to allow the VM to shut down gracefully
        }

        # Put the host in maintenance mode
        Set-VMHost -VMHost $esxiHost -State Maintenance -Confirm:$false
        Write-Output "Host $esxiHost is now in maintenance mode."

        # Shut down the ESXi host
        Stop-VMHost -VMHost $esxiHost -Force -Confirm:$false
        Write-Output "Host $esxiHost has been shut down."
    } catch {
        Write-Error ("Failed to shut down host {0}: {1}" -f $esxiHost, $_.Exception.Message)
    }
}

# Loop through each ESXi host and shut them down
foreach ($esxiHost in $esxiHosts) {
    Shutdown-EsxiHost -esxiHost $esxiHost
}

# Disconnect from the vCenter server
Disconnect-VIServer -Server $vcenterServer -Confirm:$false
Write-Output "Disconnected from vCenter server."
