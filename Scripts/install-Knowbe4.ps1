If (!(Test-Path "C:\temp")) {
    New-Item "C:\temp" -ItemType Directory -Force | Out-Null
}

#download from HP 


invoke-webrequest -URI "https://github.com/jjonkers/OSDCloud/raw/refs/heads/main/Bin/KnowBe4/PhishAlertButtonSetup.exe" -Outfile "c:\temp\PhishAlertButtonSetup.exe" 

#run


Start-Process c:\temp\PhishAlertButtonSetup.exe  -Argumentlist '/q /ComponentArgs "KnowBe4 Phish Alert Button":"LICENSEKEY=""EU40F79010C44EDA4611BDB5830C472C95"""'