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

$evm.log("info", "VM Name - #{vm.name}")
$evm.log("info", "VM UID - #{vm.uid_ems}")
$evm.log("info", "RHEVM Name - #{ext_management_system.name}")
$dialog_name = ' '
$evm.root.attributes.sort.each { |k, v| 
   $evm.log("info","#{k}---#{v}") 
   if "#{k}" == "dialog_name" 
     $dialog_name = "#{v}"
    $evm.log("info", "Found #{$dialog_name}")
   end
 }    

rhevm = "https://#{ext_management_system.ipaddress}/api/templates"
rhevadmin = 'admin@internal'
rhevadminpass = 'monster'
resource = RestClient::Resource.new(rhevm, :user => rhevadmin, :password => rhevadminpass)
createTemplate = resource.post "<template><name>#{$dialog_name}</name><vm id=\"#{vm.uid_ems}\"></vm></template>", :content_type => 'application/xml', :accept => 'application/xml'   
$evm.log("info", "Result - #{createTemplate}")

#
#
#
$evm.log("info", "Automate Method Ended")
exit MIQ_OK
