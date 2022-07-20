$Servers = "ADSO01", "ADFS02"
$Ports = "135",
"389",
"636",
"3268",
"3269",
"53",
"88",
"445"
 
$Destination = "DC01"
$Results = @()
$Results = Invoke-Command $Servers { param($Destination, $Ports)
    $Object = New-Object PSCustomObject
    $Object | Add-Member -MemberType NoteProperty -Name "ServerName" -Value $env:COMPUTERNAME
    $Object | Add-Member -MemberType NoteProperty -Name "Destination" -Value $Destination
    Foreach ($P in $Ports) {
        $PortCheck = (Test-NetConnection -Port $p -ComputerName $Destination ).TcpTestSucceeded
        If ($PortCheck -notmatch "True|False") { $PortCheck = "ERROR" }
        $Object | Add-Member Noteproperty "$("Port " + "$p")" -Value "$($PortCheck)"
    }
    $Object
} -ArgumentList $Destination, $Ports | Select-Object * -ExcludeProperty runspaceid, pscomputername
 
$Results | Out-GridView -Title "Testing Ports"
 
$Results | Format-Table -AutoSize