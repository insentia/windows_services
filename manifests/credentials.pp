# == Class: windows_services
#
# This module allow you to manage credential of a windows_services
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_services::credentials{'puppet':
#    username    = "DOMAIN\User",
#    password    = "P@ssw0rd",
#    servicename = "puppet",
#  }
# === Authors
#
# Jerome RIVIERE (www.jerome-riviere.re)
#
# === Copyright
#
# Copyright 2014 Jerome RIVIERE, unless otherwise noted.
#
define windows_services::credentials(
  $username    = '',
  $password    = '',
  $servicename = '',
  $delayed     = false,
  $carbondll   = "C:\\Carbon.dll",
){
  if(empty($username)){
    fail('Username is mandatory')
  }
  if(empty($password)){
    fail('Password is mandatory')
  }
  if(empty($servicename)){
    fail('servicename is mandatory')
  }
  validate_bool($delayed)
  file{"${carbondll}":
    source => "puppet:///modules/windows_services/Carbon.dll",
    source_permissions => ignore,
  }
  exec{"Change credentials - $servicename":
    command  => "\$username = '${username}';\$password = '${password}';\$privilege = \"SeServiceLogonRight\";[Reflection.Assembly]::LoadFile(\"${carbondll}\");[Carbon.LSA]::GrantPrivileges(\$username, \$privilege);\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";\$StopStatus = \$svcD.StopService();\$ChangeStatus = \$svcD.change(\$null,\$null,\$null,\$null,\$null,\$null,\$username,\$password,\$null,\$null,\$null);\$startstatus = \$svcD.StartService();",
    provider => "powershell",
    timeout  => 300,
    onlyif   => "\$username = '${username}';\$password = '${password}';\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";if(\$svcD.GetPropertyValue('startname') -like '${username}'){exit 1}",
  }

  if($delayed){
    $value = '1' 
  }else{
    $value = '0'
  }

  exec{"Set Start_Delayed - $servicename":
    command  => "New-ItemProperty -Path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\" -Name 'DelayedAutoStart' -Value '${value}' -PropertyType 'DWORD' -Force;",
    provider => "powershell",
    timeout  => 300,
    onlyif   => "if((test-path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\\\") -eq \$true){if((Get-ItemProperty -Path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\" -ErrorAction SilentlyContinue).DelayedAutoStart -eq '${value}'){exit 1;}else{exit 0;}}else{exit 1;}",
  }
  File["${carbondll}"] -> Exec["Change credentials - $servicename"] -> Exec["Set Start_Delayed - $servicename"]
}