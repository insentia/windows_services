# windows_services

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with windows_services](#setup)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Support - How contribute](#Support)

## Overview

Module allow us to change the username and password for a service.

## Module Description

Module allow us for now to change the username and password for a service.

Delayed resource can't be applied without a server restart.

##Last Fix/Update
V 0.0.4 :
 - Add Carbon.dll assembly. Permit to give privilege : SeServiceLogonRight to the specify account (useful for managing server without DC features)

## Setup

### Setup Requirements

Depends on the following modules:
['puppetlabs/powershell', '>=1.0.2'](https://forge.puppetlabs.com/puppetlabs/powershell),
['puppetlabs/stdlib', '>= 4.2.1'](https://forge.puppetlabs.com/puppetlabs/stdlib)


## Usage

Resource: windows_services::delayedstart
```
	windows_services::delayedstart{'puppetdelayed':
	  servicename => "puppet",
	}
```
Parameters
```
	$delayed   # Default True for put delayed start on service, set to false to let to automatic start
```

Resource: windows_services:credentials
```
	windows_services::credentials{'puppet':
	  username    => "DOMAIN\\User",
	  password    => "P@ssw0rd",
	  servicename => "puppet",
	  delayed     => true,
	}
```

Parameters
```
	$delayed   # Default False, set to true to set delayed start on servicename. (Restart needed)
```

## Limitations

Works only with windows.
Tested on Windows Server 2012 R2

The delayed resource is only applied when server reboot.

License
-------
Apache License, Version 2.0

Contact
-------
[Jerome RIVIERE](https://github.com/ninja-2)

Support
-------
Please log tickets and issues at [GitHub site](https://github.com/insentia/windows_services/issues)