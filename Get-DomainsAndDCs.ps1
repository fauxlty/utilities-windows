$array = [System.Collections.ArrayList]@()
$domainname = ""
$dc = ""
$isavailable = ""

#Check user domain for defaults
$targetdomain = $env:UserDNSDomain
Write-Host "Root target domain: $targetdomain"

foreach ($domainname in (Get-ADForest -Server $targetdomain).Domains) {
    foreach ($dc in (Get-ADDomainController -Server $domainname -Filter *).HostName) {

        $isavailable = (Test-Connection -ComputerName $dc -Count 1 -ErrorAction SilentlyContinue)

        if ($isavailable.count -ge 1 ) {
            
            $customobject = new-object -TypeName PsCustomObject
            $customobject | Add-Member -MemberType NoteProperty -Name 'Name' -Value $dc.ToUpper()
            $customobject | Add-Member -MemberType NoteProperty -Name 'Domain' -Value $domainname.ToUpper()
            $customobject | Add-Member -MemberType NoteProperty -Name 'Site' -Value (Get-ADDomainController -Server $dc).site

            $array.add($customobject) | Out-Null
        
            Write-Host "Found $dc" -ForegroundColor Green

        }
        else {
            write-host "$dc in $domainname is not available" -ForegroundColor Red
        }

    }
}

$array | Sort-Object Domain, Name, Site | Format-Table -AutoSize
$array | Sort-Object Domain, Name, Site | Export-csv .\ADDomainsAndDCs.csv -nti -force

#Close up shop
$array.Clear()
[gc]::Collect()