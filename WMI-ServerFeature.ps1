function fnWMIQuery() {
	return Get-CIMInstance -ClassName Win32_ServerFeature -NameSpace root\CIMV2
}


fnWMIQuery | Out-Gridview -Title "Get-WMIServerFeature"


