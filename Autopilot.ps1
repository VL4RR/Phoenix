## This script will check if the device is in Autopilot. If it is, it will print the group tag of the device.
## It will then proceed to remove the Intune record if required, then install Windows & drivers

$winVer = "Windows 11 23H2 x64"

function MgGraph-Authentication {

    ## Credentials required to auth ##
    try { 
        Write-Host "Connecting to MS Graph..." -ForegroundColor Cyan
        
        Write-Host "#######################################################################" -ForegroundColor Green
        Write-Host "## FOLLOW THE INSTRUCTIONS BELOW TO AUTHENTICATE TO BUILD THE DEVICE ##" -ForegroundColor Green
        Write-Host "#######################################################################`n" -ForegroundColor Green
        
        Connect-MgGraph -UseDeviceCode -NoWelcome
        Write-Host "Connected successfully" -ForegroundColor Green
        downloadPreReqs

    } catch {
        Write-Host "Error connecting to graph: $_." -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
    }
}

$grouptag = Read-Host -Prompt "Group Tag"
Write-Host "Group Tag entered: $grouptag" -ForegroundColor Cyan

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Write-Host "Setting Security Protocol" -ForegroundColor Cyan

    PowerShell.exe -ExecutionPolicy Bypass
    Write-Host "Execution Policy set to Bypass" -ForegroundColor Cyan

    Install-Script -name Get-WindowsAutopilotInfo -Force
    Write-Host "Get-WindowsAutopilotInfo script installed" -ForegroundColor Cyan

    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
    Write-Host "Execution Policy set to RemoteSigned" -ForegroundColor Cyan

    Get-WindowsAutopilotInfo -Online -grouptag "$grouptag"
    Write-Host "Get-WindowsAutopilotInfo executed" -ForegroundColor Cyan
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

MgGraph-Authentication
