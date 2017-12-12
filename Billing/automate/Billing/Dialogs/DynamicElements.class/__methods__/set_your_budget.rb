#
# Description: cost_of_this_service
#

$evm.log("info","*********** STARTED #{$evm.object.name} ***********")
dialog_field = $evm.object

remaining_budget = $evm.root['dialog_remaining_budget'].to_i
your_budget = $evm.root['dialog_your_budget'].to_i
tenant = $evm.root['tenant']

$evm.log("info","Tenant Name = #{tenant.name}")
$evm.log("info","remaining_budget = #{remaining_budget}")
$evm.log("info","your_budget = #{your_budget}")

def create_budget_tag(tenant, your_budget_tag)
  $evm.log("info","Created Tag = #{your_budget_tag}")
  $evm.execute('tag_create','billing',:name => "#{your_budget_tag}",:description => "#{your_budget_tag}")
end

def assign_budget_tag(tenant,your_remaining_budget_tag)
  $evm.log("info","ASSIGN your_budget_tag = #{your_remaining_budget_tag}")
  tenant.tag_assign("billing/#{your_remaining_budget_tag}")
end

def remove_budget_tag(tenant,your_budget_tag)
  $evm.log("info","UNASSIGN your_budget_tag = #{your_budget_tag}")
  tenant.tag_unassign("billing/#{your_budget_tag}")
end

tenant_tag_name = tenant.name.downcase
tenant_tag_name = tenant_tag_name.delete(' ')
your_remaining_budget_tag = tenant_tag_name + '_budget_' + remaining_budget.to_s
your_budget_tag = tenant_tag_name + '_budget_' + your_budget.to_s

unless $evm.execute('tag_exists?', 'billing', "#{your_remaining_budget_tag}")
  create_budget_tag tenant,your_remaining_budget_tag
end

assign_budget_tag tenant,your_remaining_budget_tag
remove_budget_tag tenant,your_budget_tag

#return text box value
dialog_field["value"] = remaining_budget



$evm.log("info","*********** ENDED #{$evm.object.name} ***********")
