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

  exec{"Change credentials - $servicename":
    command  => "\$username = '${username}';\$password = '${password}';\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";\$StopStatus = \$svcD.StopService();\$ChangeStatus = \$svcD.change(\$null,\$null,\$null,\$null,\$null,\$null,\$username,\$password,\$null,\$null,\$null);\$startstatus = \$svcD.StartService();",
    provider => "powershell",
    timeout  => 300,
    onlyif   => "\$username = '${username}';\$password = '${password}';\$serverName = \$env:COMPUTERNAME;\$service = '${servicename}';\$svcD=gwmi win32_service -computername \$serverName -filter \"name='\$service'\";if(\$svcD.GetPropertyValue('startname') -like '${username}'){exit 1}",
  }
}