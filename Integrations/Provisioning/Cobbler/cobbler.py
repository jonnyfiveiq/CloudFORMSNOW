#!/usr/bin/env python
import xmlrpclib
import getopt
import string
import sys

SATELLITE_USER="satadmin"
SATELLITE_PASSWORD="passowrd"

def usage():
    print """\
    cobbler.py [options]

    Options:
      -h, --help		brief help message
      -S, --server=		FQDN of the Cobbler Server
      -n, --name=		Cobbler System Record name
      -H, --hostname=   	Hostname of the System
      -i, --ip-address= 	IP Address
      -s, --subnet=		Subnetmask
      -m, --mac-address=	MAC Address
      -g, --gateway=		Gateway
      -p, --profile=		Kickstartprofile to use
      -k, --ksmeta=		Kickstart Metainformation
				'foo=bar bar=foo key=value'

    [Connect to cobbler over XMLRPC and create a cobbler system record]
    """

#      -I, --interface=		Network Interface e.g. eth0

try:
     opts, args = getopt.getopt(sys.argv[1:],
                                "hS:n:H:I:i:s:m:g:p:k:",
                                ["help",
                                 "server=",
		                 "name=",
                		 "hostname=",
				 "interface=",
				 "ip-address=",
				 "subnet=",
				 "mac-address=",
				 "gateway=",
				 "profile=",
				 "ksmeta="])
except getopt.GetoptError, err:
	print "\n" + str(err) + "\n"
     	usage()
     	sys.exit(1)

	opt_server = None
	opt_name = None
	opt_hostname = None
	opt_interface = None
	opt_ip_address = None
	opt_subnet = None
	opt_mac_address= None
	opt_gateway = None
	opt_profile = None
	opt_ksmeta= None

for o, a in opts:
    if o in ("-h", "--help"):
        usage()
        sys.exit()
    elif o in ("-S", "--server"):
        opt_server= a
    elif o in ("-n", "--name"):
        opt_name = a
    elif o in ("-H", "--hostname"):
        opt_hostname = a
    #elif o in ("-I", "--interface"):
    #    opt_interface = a
    elif o in ("-i", "--ip-address"):
        opt_ip_address = a
    elif o in ("-s", "--subnet"):
        opt_subnet = a
    elif o in ("-m", "--mac-address"):
        opt_mac_address = a
    elif o in ("-g", "--gateway"):
        opt_gateway = a
    elif o in ("-p", "--profile"):
        opt_profile = a
    elif o in ("-k", "--ksmeta"):
        opt_ksmeta = a
    else:
        assert False, "unhandled option " + o


server =  xmlrpclib.Server("http://"+opt_server+"/cobbler_api")
token = server.login(SATELLITE_USER,SATELLITE_PASSWORD)
system_id = server.new_system(token)
server.modify_system(system_id,"name", opt_name,token)
server.modify_system(system_id,"hostname", opt_hostname,token)
server.modify_system(system_id,'modify_interface', {
			        "macaddress-eth0"   : opt_mac_address,
			        "ipaddress-eth0"    : opt_ip_address,
			        "subnet-eth0"       : opt_subnet,
				"static-eth0"       : "true",
				}, token)
server.modify_system(system_id,"gateway", opt_gateway, token)
server.modify_system(system_id,"profile", opt_profile, token)
server.modify_system(system_id,"ks_meta", opt_ksmeta, token)

server.save_system(system_id, token)
server.sync(token)
