#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os
import commands
import time, locale, datetime
import list_data
import webbrowser

#from urlparse import urlparse
from pykeyboard import PyKeyboard

## static variables
DEBUG2 = 1


openItvl = 10
closeItvl = 5
Itvl = 2
outputDir = "./gen"

default_explore = "Google\ Chrome.app"
#default_explore = "Safari.app"
default_explore = "Firefox.app"

k = PyKeyboard()


def force_utf8_hack():
    reload(sys)
    sys.setdefaultencoding('utf-8')
    for attr in dir(locale):
        if attr[0:3] != 'LC_':
            continue
        aref = getattr(locale, attr)
        locale.setlocale(aref, '')
        (lang, enc) = locale.getlocale(aref)
        if lang != None:
            try:
                locale.setlocale(aref, (lang, 'UTF-8'))
            except:
                os.environ[attr] = lang + '.UTF-8'

if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit('Usage ./open_web.py FileName WebSite')

    fileName = sys.argv[1]
    website = sys.argv[2]
    force_utf8_hack()

    open_file = "%s/%s.web_time.txt" %(outputDir,fileName)

    with open(open_file, "w") as myfile:

        #open an explorer, and sleep for a while
        cmd = "open /Applications/%s " %(default_explore)
        os.system(cmd)
        time.sleep(closeItvl)

        k.press_keys(['Command','alternate','q'])
        time.sleep(Itvl)

        k.press_keys(['Command','`'])
        time.sleep(closeItvl)

        k.type_string(website)
        time.sleep(Itvl)
        k.press_key('return')

        c_time = datetime.datetime.now().time()
        c_time = c_time.isoformat()
        logstamp = "%s,%s\n" % (c_time, 'web')
        myfile.write(logstamp)

        time.sleep(openItvl)
