Param (
  [Parameter(Mandatory = $True, Position = 1, HelpMessage = "Please enter your email address")]
  [ValidateNotNullorEmpty()]
  [string]$YourEmailAddress,
  
  [Parameter(Mandatory = $True, Position = 2, HelpMessage = "Please choose company name:Customer1,Customer2 or Customer2")]
  [ValidateSet('Customer1', 'Customer2', 'Customer3')]
  [ValidateNotNullorEmpty()]
  [string]$CompanyName,
  
  [Parameter(Mandatory = $False, Position = 3, HelpMessage = "Please enter assgin users's UserPrincipalName")]
  [string]$assignedUserPrincipalName
)



$Serial = (Get-WmiObject  -Class Win32_BIOS).SerialNumber
$DeviceHardwareData = (Get-WMIObject -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'").DeviceHardwareData

$body = @"
{
 "orderIdentifier": $($CompanyName),
 "serialNumber": $($Serial),
 "hardwareIdentifier": $($DeviceHardwareData),
 "EmailAddress": $($YourEmailAddress),
 "assignedUserPrincipalName" : $($assignedUserPrincipalName)
}
"@

#Change this to your Flow HTTP request url
$Url = "https://prod-98.westeurope.logic.azure.com:443/workflows/38eebac34d2a46119f7fb3c165e73b5d/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%"

try
{
  #Make REST API call to flow
  Invoke-RestMethod -uri $Url -Method Post -body $Body -ContentType 'application/json'
  Write-Output "Please wait for email confirmation for approval to continue install this device"
}
catch
{
  Write-Error "$_.Exception.Message"
}
