#
# EVM Automate Method
#
$evm.log("info", "EVM Automate Method Started")
#
# Method Code Goes here
#
export_location = "/vmExport/"
vm = $evm.root['vm']
ems = vm.ext_management_system
$evm.log("info","VM Name = #{vm.name}")
$evm.log("info","vCenter Name = #{ems.name}")
 
dir = export_location + vm.vendor
ovftool = "/usr/bin/ovftool "
arguments = "vi://#{ems.authentication_userid}:#{ems.authentication_password}@#{ems.ipaddress}/#{vm.v_owning_datacenter}?ds=[#{vm.storage_name}]/#{vm.location} #{dir}/#{vm.name}"
command = ovftool + arguments
$evm.log("info","Launching Command - #{command}")
begin
rc = system(command)
rescue
$evm.log("info","OVFTOOL Return - #{rc}")
end
 
#
#
#
$evm.log("info", "EVM Automate Method Ended")
exit MIQ_OK
