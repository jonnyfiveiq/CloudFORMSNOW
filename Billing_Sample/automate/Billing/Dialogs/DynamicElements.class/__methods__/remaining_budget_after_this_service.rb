#
# Description: cost_of_this_service
#

$evm.log("info","*********** STARTED #{$evm.object.name} ***********")
dialog_field = $evm.object

your_budget = $evm.root['dialog_your_budget'].to_i
cost_of_this_service = $evm.root['dialog_cost_of_this_service'].to_i

remaining_budget = your_budget - cost_of_this_service

$evm.log("info","your_budget = #{your_budget}")
$evm.log("info","cost_of_this_service = #{cost_of_this_service}")
$evm.log("info","remaining_budget = #{remaining_budget}")

#return text box value
dialog_field["value"] = remaining_budget

$evm.log("info","*********** ENDED #{$evm.object.name} ***********")
