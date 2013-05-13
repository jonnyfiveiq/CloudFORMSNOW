###################################
# EVM Automate Method: call_CFME.rb
# Notes: This method is used to call CFME via SOAP to run an automate method
#
###################################
# Method for logging
def log(level, message)
  @method = 'call_CFME'
  puts "#{@method} - #{message}"
end

begin
  log(:info, "Method Started")

  #################################
  # Method: buildBody
  # Notes: Build a hash of values for the automation request
  #################################
  def build_body_hash(cfme_namespace, cfme_class, cfme_instance, parms)
    body_hash = {}
    body_hash['version'] = '1.1'
    body_hash['uri_parts'] = "namespace=#{cfme_namespace}|class=#{cfme_class}|instance=#{cfme_instance}|message=create"
    body_hash['parameters'] = parms
    body_hash['requester'] = "auto_approve=true"
    return body_hash
  end

  #################################
  # Method: createAutomationRequest
  # Notes: Create a SOAP call to EVM and submit an Automation Request
  #################################
  def createAutomationRequest(body_hash, username, password, servername)
    gem 'savon', '0.8.5'

    require 'rubygems'
    require 'savon'
    require 'httpi'

    HTTPI.log_level = :debug # changing the log level
    HTTPI.log = false
    HTTPI.adapter = :net_http # [:httpclient, :curb, :net_http]

    # Setup Savon Configuration
    Savon.configure do |config|
      config.log = false
      config.log_level = :debug # changing the log level
    end


puts username
puts password
puts servername
puts body_hash
    
    
    # Set up Savon client
    client = Savon::Client.new do |wsdl, http|
      wsdl.document = "https://#{servername}/vmdbws/wsdl"
      http.auth.basic username, password
      http.auth.ssl.verify_mode = :none
    end

    response = client.request :create_automation_request do
      soap.body = body_hash
    end
    return response.to_hash
  end

  # Set username, password, CFME Server below
  username, password, servername = 'ws', 'smartvm', '192.168.201.20'

 
  
  # Build a hash with the path to the instance you want to run
  body_hash = build_body_hash('Sample', 'Methods', 'demo', 'foo=bar|hello=world')
  
  # Call CFME via SOAP
  request_hash = createAutomationRequest(body_hash, username, password, servername)

  log(:info, "Request Returned: #{request_hash.inspect}")
  log(:info, "Automation Request Id: #{request_hash[:create_automation_request_response][:return].inspect}")


  # Exit method
  log(:info, "Method Ended")
  exit 

  # Set Ruby rescue behavior
rescue => err
  log(:error, "[#{err}]\n#{err.backtrace.join("\n")}")
  exit
end
