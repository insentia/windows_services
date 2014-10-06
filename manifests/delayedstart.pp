# == Class: windows_services
#
# This module allow you to set a delayed start on a service
#
# === Parameters
#
#  Can be found on read me
#
# === Examples
#
#  windows_services::delayedstart{'puppet':
#    delayed     = true,
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
define windows_services::delayedstart(
  $delayed     = true,
  $servicename = '',
){
  if(empty($servicename)){
    fail('servicename is mandatory')
  }

  if($delayed){
    $value = '1' 
  }else{
    $value = '0'
  }
  
  exec{"Set Delayed_start - $servicename":
    command  => "New-ItemProperty -Path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\" -Name 'DelayedAutoStart' -Value '${value}' -PropertyType 'DWORD' -Force;",
    provider => "powershell",
    timeout  => 300,
    onlyif   => "if((test-path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\\\") -eq \$true){if((Get-ItemProperty -Path \"HKLM:\\System\\CurrentControlSet\\Services\\${servicename}\" -ErrorAction SilentlyContinue).DelayedAutoStart -eq '${value}'){exit 1;}else{exit 0;}}else{exit 1;}",
  }
}