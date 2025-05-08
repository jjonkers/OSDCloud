# to disable the new Outlook icon in the Taskbar and Start Menu of Windows11 24H2

cmd /c 'reg add  "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableCloudOptimizedContent /t REG_DWORD /d 1 /f'