#!/usr/bin/python

import sys
import json
import urllib
import pycurl

system=sys.argv[2]
cloudforms="https://<CloudFORMS.SERVER>/vm/provisioned?guid="

json_data=open('/var/lib/cobbler/config/systems.d/' + system + '.json')
data = json.load(json_data)
json_data.close()

try:
    rqid = urllib.quote(data["ks_meta"]["rqid"])
    rqid = int(rqid)

except KeyError:
    rqid = "dummy"

finally:
    if type(rqid) == int:
        url = cloudforms + str(rqid)

        c = pycurl.Curl()
        c.setopt(c.URL, url)
        c.setopt(pycurl.SSL_VERIFYPEER, 0)   
        c.setopt(pycurl.SSL_VERIFYHOST, 0)
        c.perform()
