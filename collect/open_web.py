#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os
import time, locale, datetime
from pykeyboard import PyKeyboard

## static variables


# variables
openItvl = 10
closeItvl = 5
outputDir = "../data/gen/"
default_explore = "Google\ Chrome.app"
default_explore = "Safari.app"
web_idxs = range(20)

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
    if len(sys.argv) < 2:
        sys.exit('Usage ./open_web.py outputFileName')

    fileName = sys.argv[1]
    force_utf8_hack()

    input_file = "web.txt"
    output_file = "%s/%s.time.txt" %(outputDir,fileName)

    prefix = "https://www."

    f_in = open(input_file, 'r')
    lines = f_in.readlines()
    with open(output_file, "w") as f_out:
        for i, line in enumerate(lines):
            if i not in web_idxs:
                continue

            line = line.strip()
            url = prefix + line

            # open a web and sleep for a while
            c_time = str(time.time())
            logstamp = "%s %d\n" % (c_time, i+1)
            f_out.write(logstamp)

            os.system("open -a /Applications/" + default_explore + " " + url)

            time.sleep(openItvl)

            # close a web and sleep for a while
            k.press_keys(['Command','w'])
            time.sleep(closeItvl)
    f_in.close()
