#
#            Automate Method
#
$evm.log("info", "--------------------------RAVELLO APPLICATION START-----------------")
$evm.log("info", "--------------------------RAVELLO APPLICATION START-----------------")
$evm.log("info", "--------------------------RAVELLO APPLICATION START-----------------")

#
#            Method Code Goes here
#

require 'rubygems'
require 'rest_client'
require 'xmlsimple'
require 'json'
require 'cgi'


#how many students do you want?
$totalStudents = $evm.root['dialog_totalstudents'].to_i
@applicationNamePrefix = $evm.root['dialog_applicationnameprefix']
@applicationDescription = $evm.root['dialog_applicationdescription']
#hostname prefix, will result as hostnameX, example - hostname1, hostname2, hostname3...
@hostnamePrefix = $evm.root['dialog_hostnameprefix']
#Search String
@searchString = "NOreplaceNO"
#whats the bluePrint you want to use for the application(s)
@bluePrint = $evm.root['dialog_blueprint'].to_i
#whats your account username and password, use %40 for @ in case of email address
rawUsername = $evm.root['dialog_username']
rawPassword = $evm.root['dialog_password']
@username = CGI::escape(rawUsername)
@password = CGI::escape(rawPassword)

$i = 1
while $i <= $totalStudents do

  studentNumber = "%.3i" %$i
   $evm.log("info", "StudentNumber = #{studentNumber}")
  applicationName = "#{@applicationNamePrefix}-" + studentNumber.to_s
  applicationDescription = "#{@applicationDescription} - #{applicationName}"

  $evm.log("info", "Creating Application for #{applicationName}")

#create the application from a known bluePrint
  rtr = RestClient.post "https://#{@username}:#{@password}@cloud.ravellosystems.com/api/v1/applications/", {:name => "#{applicationName}", :description => "#{applicationDescription}", :baseBlueprintId => @bluePrint.to_i}.to_json, :content_type => :json, :accept => 'application/json'

#find the applicationID
  rtr_parsed = JSON.parse(rtr)
  applicationID = rtr_parsed['id']

#fetch the newly created application
  data = RestClient.get "https://#{@username}:#{@password}@cloud.ravellosystems.com/api/v1/applications/#{applicationID}", :content_type => :json, :accept => 'application/json'
  entity = JSON.parse(data)
  new = entity

  x = 0
  new['design']['vms'].each do | a |
     $evm.log("info", "Processing #{a['hostnames']}")
    if  a['hostnames'].to_s[/NOreplaceNO/].to_s == "NOreplaceNO"
      dooie = new['design']['vms'][x]['hostnames'][0]
      dooie.gsub!("NOreplaceNO",@hostnamePrefix.to_s + studentNumber.to_s)
      new['design']['vms'][x]['hostnames'][0] = dooie
       $evm.log("info", "New Hostname = #{new['design']['vms'][x]['hostnames']}")
    end
    x = x+1
  end

#save the changes back to the application
  yoyo = RestClient.put "https://#{@username}:#{@password}@cloud.ravellosystems.com/api/v1/applications/#{applicationID}", new.to_json, :content_type => :json, :accept => :json

#publish the application to Amazon
  yoyo = RestClient.post "https://#{@username}:#{@password}@cloud.ravellosystems.com/api/v1/applications/#{applicationID}/publish", {:preferredCloud => "AMAZON", :optimizationLevel => "PERFORMANCE_OPTIMIZED" , :preferredRegion => "Virginia"}.to_json, :content_type => :json, :accept => 'application/json'

  $i +=1
end


$evm.log("info", "--------------------------RAVELLO APPLICATION END-----------------")
$evm.log("info", "--------------------------RAVELLO APPLICATION END-----------------")
$evm.log("info", "--------------------------RAVELLO APPLICATION END-----------------")

#
#
#
$evm.log("info", "Automate Method Ended")
exit MIQ_OK
