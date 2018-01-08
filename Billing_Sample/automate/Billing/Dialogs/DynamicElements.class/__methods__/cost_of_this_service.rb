#
# Description: cost_of_this_service
# This method simply gets the tag prefixed with "cost_of_this_service_*" takes the last figure after underscore
# and sets the dialogfield to the value.
# Tag must be applied to the SERVICE TEMPLATE

$evm.log("info","*********** STARTED #{$evm.object.name} ***********")
dialog_field = $evm.object
@cost_of_this_service

#the object to get tags from for costing
object = $evm.root['service_template']
object_tags = object.tags
object_tags.each do |tag|
  	if tag.include? "cost_of_this_service"
      	@cost_of_this_service = tag[/([^\_]+)$/]
    	$evm.log("info","cost_of_this_service = #{@cost_of_this_service}")
	end
end

#return text box value
dialog_field["value"] = @cost_of_this_service

$evm.log("info","*********** ENDED #{$evm.object.name} ***********")
