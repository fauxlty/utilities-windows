Get-Service -Name TermService | Format-Table -AutoSize

Invoke-Command { netstat -ano | findstr -i 3389 }

reg add "\\S07497NT0154US.wmoui.wal-mart.com\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0x0 /f

Invoke-Command { reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0x0 /f }

Invoke-Command { netsh advfirewall firewall set rule group="remote desktop" new enable=Yes }

Test-NetConnection -ComputerName S07497NT0154US.wmoui.wal-mart.com -CommonTCPPort RDP

Compare-Object -ReferenceObject (AdFind.exe -h wal-mart.com -f "&(objectcategory=organizationalunit)(name=domain controllers)" -dsq | AdFind.exe -s onelevel -f objectcategory=computer -dsq) -DifferenceObject (AdFind.exe -b CN=ADDS-GPOACL-DomainControllerIsolation, OU=Groups, OU=Admins, DC=US, DC=Wal-Mart, DC=com member -list) -IncludeEqual

Compare-Object -ReferenceObject (AdFind.exe -h wal-mart.com -f "&(objectcategory=organizationalunit)(name=domain controllers)" -dsq | AdFind.exe -s onelevel -f objectcategory=computer -dsq) -DifferenceObject (AdFind.exe -b CN=ADDS-GPOACL-DomainControllerIsolation, OU=Groups, OU=Admins, DC=US, DC=Wal-Mart, DC=com member -list) -ExcludeDifferent

# AdFind.exe -b CN=ADDS-GPOACL-DomainControllerIsolation,OU=Groups,OU=Admins,DC=US,DC=Wal-Mart,DC=com member -list

# AdFind.exe -h wal-mart.com -f "&(objectcategory=organizationalunit)(name=domain controllers)" -dsq | AdFind.exe -s onelevel -f objectcategory=computer -dsq

(AdFind.exe -b CN=ADDS-GPOACL-DomainControllerIsolation, OU=Groups, OU=Admins, DC=US, DC=Wal-Mart, DC=com member -list -mvsort) | measure-object

$dcs = (AdFind.exe -b CN=ADDS-GPOACL-DomainControllerIsolation, OU=Groups, OU=Admins, DC=US, DC=Wal-Mart, DC=com member -list -mvsort); $dcs

# AdFind.exe -b CN=ADDS-GPOACL-DomainControllerIsolation,OU=Groups,OU=Admins,DC=US,DC=Wal-Mart,DC=com -vmetal

#dn:CN=ADDS-GPOACL-DomainControllerIsolation,OU=Groups,OU=Admins,DC=US,DC=Wal-Mart,DC=com

#Example: I have an entry in keepass that the name is Reset Passwords with the following in the notes

#=========================================================================================================
#labretaillink
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# Lab
# 	adfind -f samaccountname=User -dsq | admod unicodepwd::"Password" -optenc
# 	adfind -f samaccountname=cm-User -dsq | admod unicodepwd::"Password" -optenc
# 	adfind -f samaccountname=SA-User -dsq | admod unicodepwd::"Password" -optenc
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# LabSecure
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# QA
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# =========================================================================================================
# WebOnline
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# WMOUI
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# HomeOffice.Wal-Mart.com
# 	adfind -f samaccountname=cm-User -dsq | admod unicodepwd::"Password" -optenc
# Wal-Mart
# 	adfind -h wal-mart.com -f samaccountname=SA-User -dsq | admod -h wal-mart.com unicodepwd::"Password" -optenc
# =========================================================================================================
# Execute from Paw
# RunDMZ (PAW)
# 	adfind -f samaccountname=DA-User -dsq | admod unicodepwd::"Password" -optenc
# Secure (PAW)
# 	adfind -f samaccountname=EA-User -dsq | admod unicodepwd::"Password" -optenc
# 	adfind -f samaccountname=User -dsq | admod unicodepwd::"Password" -optenc

#here is the format using for /f -- for ref as well lol -- since alldc is only on the jumps
#for /f %i in ('adfind -hh wal-mart.com -sc dclist') do adfind -hh %i -rootdse currenttime -alldcd -list

# FYI - here is some syntax using alldc (instead for for /f) for quickly checking a set of dc's, etc
# alldc homeoffice.wal-mart.com "adfind -hh <server> -rootdse currenttime"

# This will find errors with auth vs just ldap respons
# alldc homeoffice.wal-mart.com "uptime \\<server>"

#Domain_IPConfigSheet.PS1 -ScriptMode FILE -File ComputerList.txt

