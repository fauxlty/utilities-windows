Get-Service -Name TermService | Format-Table -AutoSize

Invoke-Command { netstat -ano | findstr -i 3389 }

Invoke-Command { reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0x0 /f }

Invoke-Command { netsh advfirewall firewall set rule group="remote desktop" new enable=Yes }