If (!(Test-Path "C:\temp")) {
    New-Item "C:\temp" -ItemType Directory -Force | Out-Null
}

#download from HP 


invoke-webrequest -URI "https://github.com/jjonkers/OSDCloud/raw/refs/heads/main/Bin/Action1/action1_agent(De_Jong_Duke_NL).msi" -Outfile "c:\temp\action1_agent(De_Jong_Duke_NL).msi" 

#run
 
Start-Process msiexec.exe -Argumentlist '/i "c:\temp\action1_agent(De_Jong_Duke_NL).msi" ALLUSERS=1 /qn /norestart /log output.log' 



