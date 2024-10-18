## This script will check if the device is in Autopilot. If it is, it will print the group tag of the device.
## It will then proceed to remove the Intune record if required, then install Windows & drivers

$winVer = "Windows 11 23H2 x64"

function MgGraph-Authentication {

    ## Credetnails required to auth ##
    try { 
        Write-Host "Connecting to MS Graph..." -ForegroundColor Cyan
        
        Write-Host "#######################################################################" -ForegroundColor Green
        Write-Host "## FOLLOW THE INSTRUCTIONS BELOW TO AUTHENTICATE TO BUILD THE DEVICE ##" -ForegroundColor Green
        Write-Host "#######################################################################`n" -ForegroundColor Green
        
        Connect-MgGraph -UseDeviceCode -NoWelcome
        Write-Host "Connected successfuly" -ForegroundColor Green
        downloadPreReqs

    } catch {
        Write-Host "Error connecting to graph: $_." -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"

    }

}

$grouptag = Read-Host -Prompt "Group Tag"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
PowerShell.exe -ExecutionPolicy Bypass
Install-Script -name Get-WindowsAutopilotInfo -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Get-WindowsAutopilotInfo -Online -grouptag "$grouptag"
-Assign -Reboot
