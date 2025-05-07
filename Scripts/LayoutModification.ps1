

If (!(Test-Path "C:\temp")) {
    New-Item "C:\temp" -ItemType Directory -Force | Out-Null
}


invoke-webrequest -URI https://raw.githubusercontent.com/jjonkers/OSDCloud/refs/heads/main/Scripts/LayoutModification.xml -OutFile "c:\users\default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
