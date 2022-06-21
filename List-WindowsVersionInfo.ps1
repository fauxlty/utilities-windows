$WinVer = New-Object –TypeName PSObject
$WinVer | Add-Member –MemberType NoteProperty –Name Major –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMajorVersionNumber).CurrentMajorVersionNumber
$WinVer | Add-Member –MemberType NoteProperty –Name Minor –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMinorVersionNumber).CurrentMinorVersionNumber
$WinVer | Add-Member –MemberType NoteProperty –Name Build –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentBuild).CurrentBuild
$WinVer | Add-Member –MemberType NoteProperty –Name Revision –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' UBR).UBR
$WinVer | Add-Member –MemberType NoteProperty –Name ReleaseID –Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ReleaseId).ReleaseId
$WinVer | Format-Table