$evm.log('info','*******************STARTED****************')


tag = "/department/marketing"
hosts = $evm.vmdb(:vm).find_tagged_with(:all => tag, :ns => "/managed")

$evm.log("info","Looking for TAG are #{tag}")

hosts.each do |vm|
	$evm.log("info","VMs are #{vm}")
  #	vm.stop
  #  vm.remove_from_disk
  #  vm.remove_from_vmdb
end



