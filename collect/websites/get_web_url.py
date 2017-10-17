#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   Zhuang Di ZHU
#   E-mail  :   zhuangdizhu@yahoo.com
#   Date    :   17/10/16 16:47:37
#   Desc    :
#

import alexa
WEB_NUM = 500
url_tuples = alexa.top_list(WEB_NUM)
outputfile_name = 'websites/web.txt'
f = open(outputfile_name, 'w')
for (i, url) in url_tuples:
    print(i, url)
    f.write(url+'\n')
f.close()

