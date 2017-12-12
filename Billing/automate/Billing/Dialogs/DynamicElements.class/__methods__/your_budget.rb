#
# Description: cost_of_this_service
#

$evm.log("info","*********** STARTED #{$evm.object.name} ***********")
dialog_field = $evm.object
@your_budget

tenant = $evm.root['tenant']

tenant_tag_name = tenant.name.downcase
tenant_tag_name = tenant_tag_name.delete(' ')
your_budget_prefix = tenant_tag_name + '_budget_'

$evm.log("info","your_budget_prefix = #{your_budget_prefix}")

#the object to get tags from for costing
object = $evm.root['tenant']
object_tags = object.tags
object_tags.each do |tag|
  $evm.log("info","Processing Tag = #{tag} for #{your_budget_prefix}")
  	if tag.include? "#{your_budget_prefix}"
      	@your_budget = tag[/([^\_]+)$/]
    	$evm.log("info","#{your_budget_prefix.to_s} = #{@your_budget}")
	end
end

#return text box value
dialog_field["value"] = @your_budget

$evm.log("info","*********** ENDED #{$evm.object.name} ***********")
