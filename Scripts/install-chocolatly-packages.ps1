#install apps, include fullpath to chocolatey 
c:\programdata\chocolatey\choco.exe install adobereader googlechrome firefox 7zip.install notepadplusplus.install remote-desktop-client clickshare-desktop greenshot vlc -y

#download xml
invoke-webrequest https://raw.githubusercontent.com/jjonkers/OSDcloud/refs/heads/main/Scripts/Office365_x64_Online.xml -outfile  c:\temp\Office365_x64_Online.xml

#install Office365_x64_Online
c:\programdata\chocolatey\choco.exe install office365business --params "/configpath:C:\temp\Office365_x64_Online.xml" --force -y

#remove desktop icons 
remove-item c:\users\public\desktop\*.lnk
