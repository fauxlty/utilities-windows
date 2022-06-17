##Flush out vars due to debug/testing
$DcList = $null
$Subnets = $null
$ResultsArray = $null
$Subnet = $null
$RA = $null
$array = [System.Collections.ArrayList]@()

## Get a list of all domain controllers in the forest
$domainname = ""
$dc = ""
$isavailable = ""

#Check user domain for defaults
$targetdomain = $env:UserDNSDomain
Write-Host "Root target domain: $targetdomain"

foreach ($domainname in (Get-ADForest -Server $targetdomain).Domains) {
    foreach ($dc in (Get-ADDomainController -Server $domainname -Filter *).HostName) {

        $isavailable = (Test-Connection -ComputerName $dc -Count 1 -ErrorAction SilentlyContinue)

        if ($isavailable) {
            
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
    
$dclist = $array | Select-Object Site, Name, Domain

## Get all replication subnets from Sites & Services
$Subnets = Get-ADReplicationSubnet -filter * -Properties * | Select-Object Name, Site

## Create an empty array to build the subnet list
$ResultsArray = @()

## Loop through all subnets and build the list
ForEach ($Subnet in $Subnets) {

    $SiteName = ""
    If ($null -ne $Subnet.Site) { $SiteName = ($Subnet.Site -split ',*..=')[1] }

    $DcInSite = $False
    If ($DcList.Site -Contains $SiteName) { $DcInSite = $True }

    $RA = New-Object PSObject
    $RA | Add-Member -MemberType NoteProperty -name "SubnetIDString" -Value $Subnet.Name
    $RA | Add-Member -MemberType NoteProperty -name "SubnetID" -Value ([IPAddress](($Subnet.Name -split "/")[0]))
    $RA | Add-Member -MemberType NoteProperty -name "SiteName" -Value $SiteName
    $RA | Add-Member -MemberType NoteProperty -name "DcInSite" -Value $DcInSite
    $RA | Add-Member -MemberType NoteProperty -Name "MaskBits" -Value ([int](($Subnet.Name -split "/")[1]))
    $RA | Add-Member -MemberType NoteProperty -Name "SubnetMask" -Value ([IPAddress]"$([system.convert]::ToInt64(("1"*$RA.MaskBits).PadRight(32,"0"),2))")
    ##$RA | Add-Member -type NoteProperty -name "SiteLoc"  -Value $Subnet.Location
    ##$RA | Add-Member -type NoteProperty -name "SiteDesc" -Value $Subnet.Description

    ##Test for var population
    ##if ($ra.SubnetID -ne $null) {Write-Host $ra.SiteName','$ra.SubnetID','$ra.SubnetMask','$ra.MaskBits}
    
    $ResultsArray += $RA

}

## Export the sites and subnets collection array as a CSV file
$ResultsArray | Sort-Object Subnet | Export-Csv .\AD-Subnets.csv -nti -Force


##Perform computation of subnet overlap using the current array

$SubnetOverlaps = $null
$SmallSubnets = $null
$SmallSubnet = $null

$SmallSubnets = @()

$SubnetOverlaps = foreach ($Subnet in $ResultsArray) {
    $SmallSubnets = $ResultsArray | Where-Object { $_.MaskBits -gt $Subnet.MaskBits }
    foreach ($SmallSubnet in $SmallSubnets ) {
        if (($SmallSubnet.SubnetID.Address -band $Subnet.SubnetMask.Address) -eq $Subnet.SubnetID.Address) {
            [PSCustomObject]@{
                Subnet            = $Subnet.SubnetID
                OverlappingSubnet = $SmallSubnet.SubnetID
                SubnetSite        = $Subnet.SiteName
                OverlappingSite   = $SmallSubnet.SiteName
                SiteCollision     = $Subnet.SiteName -ne $SmallSubnet.SiteName
                DCInSite          = $subnet.DcInSite
                
            }
        }
    }
}

##Export the subnet overlap results to a separate CSV file
$SubnetOverlaps | Sort-Object Subnet | Export-csv .\ADSubnetOverlap.csv -nti -force