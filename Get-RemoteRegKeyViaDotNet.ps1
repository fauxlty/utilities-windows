$Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', '$serverfqdn')
$RegistryKey = $Registry.OpenSubKey("SYSTEM\CurrentControlSet\Services\Netlogon\Parameters", $true)
$RegistryKey.GetValue('DynamicSiteName')
$RegistryKey