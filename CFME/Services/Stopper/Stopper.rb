def mark_task_invalid(task)
  task.finished("Invalid")
  task.miq_request_tasks.each do |t|
    2.times { $evm.log("info", "********************************DUMPING TASK #{t}*************************************") }
    mark_task_invalid(t)
  end
end


10.times { $evm.log("info", "*********************************************************************") }

stp_task = $evm.root["service_template_provision_task"]
miq_request_id = $evm.vmdb('miq_request_task', stp_task.get_option(:parent_task_id))
dialogOptions = miq_request_id.get_option(:dialog)

$evm.log("info", "Dialog_Environment #{dialogOptions['dialog_environment'].downcase}")
$evm.log("info", "State_Environment #{$evm.root['State_Environment'].downcase}")

if dialogOptions['dialog_environment'].downcase != $evm.root['State_Environment'].downcase
  $evm.log("info", "NO MATCH - DUMPING Service from resolution")
  task = $evm.root["service_template_provision_task"]
  mark_task_invalid(task)
  exit MIQ_STOP
end

$evm.log("info", "MATCH FOUND - Processing Service Normally")

10.times { $evm.log("info", "*********************************************************************") }






