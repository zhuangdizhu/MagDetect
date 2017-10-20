#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   Zhuang Di ZHU
#   E-mail  :   zhuangdizhu@yahoo.com
#   Date    :   17/10/19 15:32:52
#   Desc    :
#
import sys, os, signal, random, re, fnmatch, gc, csv
import time, locale, datetime, requests
import socket
import dns, dns.name, dns.query, dns.resolver, dns.exception

DEBUG1 = 1
DEBUG2 = 1
DEBUG3 = 1
DEBUG4 = 0

input_dir = "../data/gen/"

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
    if len(sys.argv) != 2:
        print("Input Example: ./preprocess_web.py 20171020.exp01")
        sys.exit()
    input_filename = sys.argv[1]

    ###################
    ## Read SensorLog Data
    ###################

    if DEBUG2: print "Read SensorLog Data"

    f = open(input_dir + input_filename + ".mag.txt", 'w')

    with open(input_dir + input_filename + ".mag.csv", 'rb') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
        spamreader = list(spamreader)
        spamreader.pop(0)
        cnt = 0
        for row in spamreader:
            try:
                ts = float(row[3])
                magx = float(row[4])
                magy = float(row[5])
                magz = float(row[6])
                f.write("%.5f,%.2f,%.2f,%.2f\n" %(ts, magx, magy, magz))
                print("%.5f,%.2f,%.2f,%.2f\n" %(ts, magx, magy, magz))
            except Exception as e:
                continue




