# ==============================================================================
# Script:      Test-Ports.ps1
# Author:      Philippe Lambermon (@dapkor)
# Copyright:   (c) Philippe Lambermon. All rights reserved.
# ==============================================================================

#Function Logic
Function Test-Ports {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$IP,
        [int[]]$Ports
    )

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "   Network Report for: $IP" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    # Ping details
    $pingResult = Test-NetConnection -ComputerName $IP -InformationLevel Detailed -WarningAction SilentlyContinue

    $openPorts = [System.Collections.Generic.List[int]]::new()
    $closedPorts = [System.Collections.Generic.List[int]]::new()

    $i = 0
    foreach ($port in $Ports) {
        $i++
        Write-Progress -Activity "Scanning $IP" -Status "Checking port $port ($i/$($Ports.Count))" -PercentComplete (($i / $Ports.Count) * 100)
        $result = Test-NetConnection -ComputerName $IP -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet
        if ($result) { 
            $openPorts.Add($port)
        } else { 
            $closedPorts.Add($port)
        }
    }
    Write-Progress -Activity "Scanning $IP" -Completed

    # Samenvatting
    Write-Host "Connectivity:" -ForegroundColor Yellow
    Write-Host "  Ping Succeeded:            $($pingResult.PingSucceeded)"
    Write-Host "  Name Resolution Succeeded: $($pingResult.NameResolutionSucceeded)"
    
    Write-Host "Port Status:" -ForegroundColor Yellow
    if ($openPorts.Count -gt 0) {
        Write-Host "  OPEN Ports ($($openPorts.Count)):   $($openPorts -join ', ')" -ForegroundColor Green
    } else {
        Write-Host "  OPEN Ports:       None" -ForegroundColor Gray
    }
    
    if ($closedPorts.Count -gt 0) {
        Write-Host "  CLOSED Ports ($($closedPorts.Count)): $($closedPorts -join ', ')" -ForegroundColor Red
    }
    Write-Host "========================================`n" -ForegroundColor Cyan
}


# INPUT VARIABLES Define you IP's & ports tp scam
$Ports = @(80, 22222, 1502, 502)
$IPs = @("192.168.178.150", "192.168.178.100")

# Run Function
foreach ($Address in $IPs) {
    Test-Ports -IP $Address -Ports $Ports
}
