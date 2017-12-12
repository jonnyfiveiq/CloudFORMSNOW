#
# Description: status
#

$evm.log("info","*********** STARTED #{$evm.object.name} ***********")
dialog_field = $evm.object

remaining_budget = $evm.root['dialog_remaining_budget'].to_i
your_budget = $evm.root['dialog_your_budget'].to_i
tenant = $evm.root['tenant']

if remaining_budget < 0 
  #return text box value
    $evm.log('info',"#{tenant.name} are OVER budget by #{remaining_budget}")
	dialog_field["value"] = "#{tenant.name} are OVER budget by #{remaining_budget}"
  else
  #return text box value
    $evm.log('info',"Quota OK")
	dialog_field["value"] = "Quota OK"
end





$evm.log("info","*********** ENDED #{$evm.object.name} ***********")
