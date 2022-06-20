#Vars
$TypeTable = [System.Management.Automation.Runspaces.TypeTable]::LoadDefaultTypeFiles()
$ServerSpace = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateOutOfProcessRunspace($TypeTable)


#Get-Content server list


#Get server count to map to runspace count

#for-each server, run test connection code

#Spawn runspaces

#Test connection code

$Server.Runspace

#Check runspaces to see which have completed
Get-Runspace.count

$dcCompleted = $ServerSpace.iscompleted()

#If ($serverlist.count -gt $dcCompleted)

#Pull available values from each of the DC's runspaces and put them into an Array.List() via $serverspace



$ServerSpace.Dispose()