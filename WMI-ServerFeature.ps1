#========================================================================
# Created with:	SAPIEN Technologies, Inc., WMI Explorer 2018 Version 2.2.77
# Created on:	7/9/2018 9:14:35 PM
# Created by:	
# Organization:	
# Filename:		WMI-ServerFeature
#========================================================================

function Run-WMIQuery()
{
	return Get-CIMInstance -ClassName Win32_ServerFeature -NameSpace root\CIMV2
}


Run-WMIQuery | Out-Gridview -Title "Get-WMIServerFeature"


