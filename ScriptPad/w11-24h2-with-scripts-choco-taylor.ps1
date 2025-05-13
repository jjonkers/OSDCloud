#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force   

#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSVersion = "Windows 11"
    OSBuild = "24H2"
    OSEdition = "Pro"
    OSLanguage = "en-us"
    OSLicense = "Retail"
    ZTI = $true
    Firmware = $false
}
Start-OSDCloud @Params


#================================================
#  [PostOS] OOBEDeploy Configuration
#================================================
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json"
$OOBEDeployJson = @'
{
    "AddNetFX3":  {
                      "IsPresent":  true
                  },
    "Autopilot":  {
                      "IsPresent":  true
                  },
    "RemoveAppx":  [
                    "MicrosoftTeams",
                    "Microsoft.BingWeather",
                    "Microsoft.BingNews",
                    "Microsoft.GamingApp",
                    "Microsoft.GetHelp",
                    "Microsoft.Getstarted",
                    "Microsoft.Messaging",
                    "Microsoft.MicrosoftOfficeHub",
                    "Microsoft.MicrosoftSolitaireCollection",
                    "Microsoft.MicrosoftStickyNotes",
                    "Microsoft.MSPaint",
                    "Microsoft.People",
                    "Microsoft.PowerAutomateDesktop",
                    "Microsoft.StorePurchaseApp",
                    "Microsoft.Todos",
                    "microsoft.windowscommunicationsapps",
                    "Microsoft.WindowsFeedbackHub",
                    "Microsoft.WindowsMaps",
                    "Microsoft.WindowsSoundRecorder",
                    "Microsoft.Xbox.TCUI",
                    "Microsoft.XboxGameOverlay",
                    "Microsoft.XboxGamingOverlay",
                    "Microsoft.XboxIdentityProvider",
                    "Microsoft.XboxSpeechToTextOverlay",
                    "Microsoft.YourPhone",
                    "Microsoft.ZuneMusic",
                    "Microsoft.ZuneVideo", 
					"Microsoft.Office.OneNote",
					"Microsoft.OutlookForWindows"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force

#================================================
#  [PostOS] AutopilotOOBE Configuration Staging
#================================================
Write-Host -ForegroundColor Green "Define Computername:"
$Serial = Get-WmiObject Win32_bios | Select-Object -ExpandProperty SerialNumber
$TargetComputername = $Serial.Substring(4,3)

$AssignedComputerName = $TargetComputername 
Write-Host -ForegroundColor Red $AssignedComputerName
Write-Host ""

Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json"
$AutopilotOOBEJson = @"
{
    "AssignedComputerName" : "$AssignedComputerName",
    "AddToGroup":  "DEVICES_AUTOPILOT_TEST_CLSG",
    "Assign":  {
                   "IsPresent":  true
               },
    "GroupTag":  "GroupTagXXX",
    "Hidden":  [
                   "AddToGroup",
                   "AssignedUser",
                   "PostAction",
                   "GroupTag",
                   "Assign"
               ],
    "PostAction":  "Quit",
    "Run":  "NetworkingWireless",
    "Docs":  "https://google.com/",
    "Title":  "Autopilot Manual Register"
}
"@

If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$AutopilotOOBEJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.AutopilotOOBE.json" -Encoding ascii -Force

# Below a PS session for debug and testing in system context, # when not needed 
start /wait powershell.exe -NoL -ExecutionPolicy Bypass

#================================================
#  [PostOS] OOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Downloading and creating script for OOBE phase"
#Invoke-RestMethod https://raw.githubusercontent.com/AkosBakos/OSDCloud/main/Set-KeyboardLanguage.ps1 | Out-File -FilePath 'C:\Windows\Setup\scripts\keyboard.ps1' -Encoding ascii -Force
#Invoke-RestMethod https://raw.githubusercontent.com/AkosBakos/OSDCloud/main/Install-EmbeddedProductKey.ps1 | Out-File -FilePath 'C:\Windows\Setup\scripts\productkey.ps1' -Encoding ascii -Force
#Invoke-RestMethod https://check-autopilotprereq.osdcloud.ch | Out-File -FilePath 'C:\Windows\Setup\scripts\autopilotprereq.ps1' -Encoding ascii -Force
#Invoke-RestMethod https://start-autopilotoobe.osdcloud.ch | Out-File -FilePath 'C:\Windows\Setup\scripts\autopilotoobe.ps1' -Encoding ascii -Force
Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/Remove-Appx-AllUsers.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\AppxRemoval.ps1' -Encoding ascii -Force

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-hp-image-assistent.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\install-hp-image-assistent.ps1' -Encoding ascii -Force

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-action1.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\install-action1.ps1' -Encoding ascii -Force

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/LayoutModification.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\LayoutModification.ps1 ' -Encoding ascii -Force

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/DisableCloudOptimizedContent.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\DisableCloudOptimizedContent.ps1 ' -Encoding ascii -Force

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-Knowbe4.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\install-Knowbe4.ps1' -Encoding ascii -Force



#Choco

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-chocolatly.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\install-chocolatly.ps1' -Encoding ascii -Force

Invoke-RestMethod https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-chocolatly-packages.ps1 | Out-file -FilePath 'c:\windows\setup\scripts\install-chocolatly-packages.ps1' -Encoding ascii -Force




$OOBECMD = @'
@echo off
# Execute OOBE Tasks
#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\Setup\Scripts\keyboard.ps1
#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\Setup\Scripts\productkey.ps1
#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\Setup\Scripts\autopilotprereq.ps1

start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\AppxRemoval.ps1

#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\install-hp-image-assistent.ps1

start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\install-action1.ps1

start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\LayoutModification.ps1 

start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\DisableCloudOptimizedContent.ps1 

#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\install-chocolatly.ps1

#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\install-chocolatly-packages.ps1

#start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\setup\scripts\install-chocolatly-packages.ps1\install-Knowbe4.ps1

#Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-chocolatly.ps1

#Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/install-chocolatly-packages.ps1




# Below a PS session for debug and testing in system context, # when not needed 
#start /wait powershell.exe -NoL -ExecutionPolicy Bypass

exit 
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\Setup\scripts\oobe.cmd' -Encoding ascii -Force

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot