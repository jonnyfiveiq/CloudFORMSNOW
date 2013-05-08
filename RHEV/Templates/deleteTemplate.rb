#
#            Automate Method
#
$evm.log("info", "Automate Method Started")
#
#            Method Code Goes here
#

#!/usr/bin/ruby
require 'rubygems'
require 'rest_client'

vm = $evm.root['vm']
ext_management_system = vm.ext_management_system

$evm.log("info", "Template Name - #{vm.name}")
$evm.log("info", "Template UID - #{vm.uid_ems}")
$evm.log("info", "RHEVM Name - #{ext_management_system.name}")

rhevm = "https://#{ext_management_system.ipaddress}/api/templates"
rhevadmin = 'admin@internal'
rhevadminpass = 'monster'
resource = RestClient::Resource.new(rhevm, :user => rhevadmin, :password => rhevadminpass)
deleteTemplate = resource.delete
$evm.log("info", "Result - #{deleteTemplate}")

#
#
#
$evm.log("info", "Automate Method Ended")
exit MIQ_OK
