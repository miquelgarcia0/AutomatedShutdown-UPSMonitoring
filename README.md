# AutomatedShutdown-UPSMonitoring
This project / reppository, contains a solution to automate a graceful shutdown of VMware machines and ESXi / vCenter hosts when a UPS battery reaches critical % levels.

**IN PROGRESS**

# Overview
This solution will constantly monitor the UPS device status and battery percentage. Main process:
1. Monitors UPS status and battery levels using the NUT UPS tool via SNMP.
2. Triggers an automated powershell script to execute a graceful shutdown of virtual machines and ESXi hosts.
3. Ensures system resilience by mitigating risks of data loss during power outages.

## Key Features
- **SNMP Monitoring:** Configures the UPS device to communicate battery and status information via SNMP.
- **Automation:** Uses cron jobs and Bash scripting to continuously monitor UPS status.
- **Graceful Shutdown:** Executes a PowerShell script with PowerCLI to shut down VMs and ESXi hosts sequentially.
- **Cross-Site Capability:** Scalable design allows monitoring and management of UPS devices across multiple global sites.

## Technologies Used
- **Linux:** Host server running on an Azure VM or any virtualization environment.
- **NUT UPS Tool:** Open-source monitoring tool for UPS devices.
- **SNMP:** Communication protocol for UPS monitoring.
- **Bash Scripting:** Automates UPS status checks and script execution also using crontab.
- **PowerShell & PowerCLI:** Manages VMware virtual machines and ESXi hosts.
- **Docker:** (Optional) Dockerize the whole app and run it from containers.
- **Azure:** Cloud platform hosting the Linux VM or Docker containers.

## Repository Structure
```
automated-ups-shutdown/
│
├── scripts/
│   ├── check-ups-status.sh          # Bash script to monitor UPS status and battery level
│   ├── script_shutdown_esxi.ps1     # PowerShell script using PowerCLI to shut down VMs and ESXi
│   └── pending
│
├── config/
│   ├── ups.conf                     # Example configuration file for NUT UPS tool main file
│   ├── crontab-example.txt          # Sample crontab entry for automation
│
├── README.md                        # Comprehensive documentation for the project

```

## Prerequisites
- Linux server (e.g., Ubuntu or CentOS) running on a Virtualization environment or Cloud (Azure, AWS, GCP...).
- VMware ESXi hosts and vCenter configured.
- Access to the UPS device with SNMP enabled.
- Installed tools:
  - NUT UPS tools
  - PowerShell with PowerCLI module

## Setup Instructions

### 1. Configure NUT UPS Tool
1. Install the NUT UPS tool on your Linux server.
2. Configure the `ups.conf` and `upsd.conf` files to connect to your UPS device via SNMP.
3. Test the connection using the NUT client to ensure proper communication.

### 2. Deploy Scripts
1. Copy the `check-ups-status.sh` script to your Linux server.
2. Configure a crontab entry using `crontab-example.txt` to run the script periodically.
3. Place the `trigger-shutdown.ps1` script on a machine with PowerCLI installed.

### 3. Test the Workflow
1. Simulate a low battery condition on the UPS to trigger the scripts.
2. Verify that VMs shut down gracefully, followed by ESXi hosts.

## Future Improvements
- Containerize the solution for easier deployment and scalability.
- Add logging and alerting mechanisms for better visibility.
- Implement redundancy to handle multiple UPS devices concurrently.

---
