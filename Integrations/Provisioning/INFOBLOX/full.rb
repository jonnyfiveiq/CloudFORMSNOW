require 'rest_client'
require 'json'
require 'nokogiri'

##################################
# Create New Network             #
##################################
def createNetwork(cdir)
	begin
		url = 'https://' + @connection + '/wapi/v1.2.1/network'
		dooie = RestClient.post url, :network => cdir
		return true
	rescue Exception => e
               puts e.inspect
               return false
        end
end

##################################
# Fetch Host	                 #
##################################
def fetchHost(host)
	begin
		url = 'https://' + @connection + '/wapi/v1.2.1/record:host'
		dooie = RestClient.get url, :name => "#{host}"
		doc = Nokogiri::XML(dooie)
                root = doc.root 
		hosts = root.xpath("value/_ref/text()")
		hosts.each do | a |
			a = a.to_s
			unless a.index(host).nil? 
				puts "Host Found - #{a}"
				return a 
			end
		end
		return true
	rescue Exception => e
		puts e.inspect
		return false
	end
end


##################################
# Get IP Address		 #
##################################
def getIP(hostname, ipaddress)
	begin
		url = 'https://' + @connection + '/wapi/v1.2.1/record:host'
		content = "\{\"ipv4addrs\":\[\{\"ipv4addr\":\"#{ipaddress}\"\}\],\"name\":\"#{hostname}\"\}"
		dooie = RestClient.post url, content, :content_type => :json, :accept => :json
		return true
	rescue Exception => e
		puts e.inspect
		return false
	end
end

##################################
# Next Available IP Address      #
##################################
def nextIP(network)
        begin
		puts "NextIP on - #{network}"
		#network = "network/ZG5zLm5ldHdvcmskMTAuOS4wLjAvMTYvMA:192.168.0.0" + "%2F" + "24/"
                url = 'https://' + @connection + '/wapi/v1.2.1/' + network
                dooie = RestClient.post url, :_function => 'next_available_ip', :num => '1'
		doc = Nokogiri::XML(dooie)
                root = doc.root
                nextip = root.xpath("ips/list/value/text()")
		puts "NextIP is - #{nextip}"
                return nextip
        rescue Exception => e
                puts e.inspect
                return false
        end
end

##################################
# Delete IP Address              #
##################################
def deleteNetwork(item)
        begin
                url = 'https://' + @connection + '/wapi/v1.2.1/' + item
		dooie = RestClient.delete url
                return true
        rescue Exception => e
                puts e.inspect
                return false
        end
end

##################################
# Fetch Network Ref              #
##################################
def fetchNetworkRef(cdir)
        begin
		puts "Network Search - #{cdir}"
               url = 'https://' + @connection + '/wapi/v1.2.1/network'
               dooie = RestClient.get url
		doc = Nokogiri::XML(dooie)
		root = doc.root
		networks = root.xpath("value/_ref/text()")
		networks.each do | a |
			a = a.to_s
			unless a.index(cdir).nil? 
				puts "Network Found - #{a}"
				return a 
			end
		end
	        return nil
        rescue Exception => e
                puts e.inspect
                return false
        end
end



###########################################
# Testing				  #
###########################################

action = "getipnext"
@num = 1
@name = 2


username = "admin"
password = "Smartvm123"
server = "173.251.12.182"
@connection = "#{username}:#{password}@#{server}"

case action

       when "deletehost"
		sooie = fetchHost("jonny#{@name}.zone.com")
		deleteHost(sooie)

	when "getipnext"
		nooie = fetchNetworkRef("10.10." + @num.to_s + ".0/24")
		kooie = nextIP(nooie)
		uooie = getIP("jonny#{@name}.zone.com",kooie)
		puts uooie
		if uooie ==  true
			puts "jonny#{@name}.zone.com with IP Address #{kooie} created successfully"
		elsif uooie == false
			puts "jonny#{@name}.zone.com with IP Address #{kooie} FAILED"
		else
			puts "unknown error"
		end

	when "getipstatic"
		uooie = getIP("jonny#{@name}.zone.com","10.9.0.#{@num}")
		if uooie ==  true
                        puts "jonny#{@name}.zone.com with IP Address #{kooie} created successfully"
                elsif uooie == false
                        puts "jonny#{@name}.zone.com with IP Address #{kooie} FAILED"
                else
                        puts "unknown error"
                end

	when "delnetwork"
		cdir = "10.10." + @num.to_s + ".0/24"
	       	nooie = fetchNetworkRef(cdir)
		unless nooie.nil?
			 fooie = deleteNetwork(nooie)
			if fooie ==  true
                        	puts "#{nooie} successfully deleted!"
                	elsif uooie == false
                        	puts "#{nooie} FAILED to delete"
                	else
                        	puts "unknown error"
                	end
		end

	when "createNetwork"
		cdir = "10.10." + @num.to_s + ".0/24"
		nooie = createNetwork(cdir)
		if nooie ==  true
                        puts "#{cdir} Network created successfully"
                elsif nooie == false
                        puts "#{cdir} Network FAILED creation"
                else
                        puts "unknown error"
                end

end
