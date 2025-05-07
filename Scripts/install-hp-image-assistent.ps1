If (!(Test-Path "C:\temp")) {
    New-Item "C:\temp" -ItemType Directory -Force | Out-Null
}
#download from HP 
invoke-webrequest -URI "https://hpia.hpcloud.hp.com/downloads/hpia/hp-hpia-5.3.1.exe" -Outfile "c:\temp\hp-hpia-5.3.1.exe" 

#run
Start-Process C:\Temp\hp-hpia-5.3.1.exe -ArgumentList '/s /e /f "C:\Program Files (x86)\HP Image Assistant"' 

#create ShortCut
$TargetFile = "C:\Program Files (x86)\HP Image Assistant\HPImageAssistant.exe"
#$ShortcutFile = "$env:Beheerder\Desktop\HP Image Assistant.lnk" 
$shortcutfile = "c:\users\public\Desktop\HP Image Assistant.lnk"
#$ShortcutFile = "c:\temp\HP Image Assistant.lnk" 
$WScriptShell = New-Object -ComObject WScript.Shell 
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile) 
$Shortcut.TargetPath = $TargetFile 
$Shortcut.Save()