#
#            Automate Method
#
$evm.log("info", "cloneTemplate -- Automate Method Started")
#
#            Method Code Goes here
#

#!/usr/bin/ruby
require 'rubygems'
require 'rest_client'

vm = $evm.root['vm']
ext_management_system = vm.ext_management_system
ems_cluster = vm.ems_cluster

$evm.log("info", "VM Name - #{vm.name}")
$evm.log("info", "RHEVM Name - #{ext_management_system.name}")
$evm.log("info", "Cluster Name - #{ems_cluster.name}")

$dialog_vm_count = ' '
$dialog_vm_prefix = ' '
$evm.root.attributes.sort.each { |k, v| 
   $evm.log("info","#{k}---#{v}") 
   if "#{k}" == "dialog_vm_count" 
     $dialog_vm_count = "#{v}"
    $evm.log("info", "Found #{$dialog_vm_count}")
   end
  
   if "#{k}" == "dialog_vm_prefix" 
     $dialog_vm_prefix = "#{v}"
    $evm.log("info", "Found #{$dialog_vm_prefix}")
   end
  
 }    

rhevm = "https://#{ext_management_system.ipaddress}/api/vms"
rhevadmin = 'admin@internal'
rhevadminpass = 'monster'
resource = RestClient::Resource.new(rhevm, :user => rhevadmin, :password => rhevadminpass)

$i = 1
while $i < ($dialog_vm_count.to_i + 1)  do
  $evm.log("info", "******** <vm><name>#{$dialog_vm_prefix}#{$i}</name><cluster><name>#{ems_cluster.name}</name></cluster><template><name>#{vm.name}</name></template><memory>4294967296</memory><os><boot dev='hd'/></os></vm>****")
  cloneTemplate = resource.post "<vm><name>#{$dialog_vm_prefix}#{$i}</name><cluster><name>#{ems_cluster.name}</name></cluster><template><name>#{vm.name}</name></template><memory>4294967296</memory><os><boot dev='hd'/></os></vm>", :content_type => 'application/xml', :accept => 'application/xml'
  $evm.log("info", "Result - #{cloneTemplate}")
  $i +=1
end



#
#
#
$evm.log("info", "Automate Method Ended")
exit MIQ_OK
