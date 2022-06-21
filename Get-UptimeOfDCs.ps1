$Server = ""
$ServerList = ""
$ServerUptime = ""

#Manual list
#$ServerList = Get-Content -Path D:\SEID\Admins\JLC\Coding\PowerShell\patching-list-domaincontrollers.csv
#$ServerList = @($server,$server2,$server3)

#Get list from file
$ServerList = Get-Content -Path D:\SEID\Admins\JLC\Coding\PowerShell\Reboot-Cycle.txt

Write-Host "Checking $($ServerList.count) Servers"
foreach ($Server in $ServerList) {
    $ServerUptime = Get-uptime $server
    Write-host $ServerUptime
}