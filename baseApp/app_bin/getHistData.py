import requests
import re
import time
import csv

histData = []

def getHistData(tf, tp, symbol):
  baseurl = 'https://www.google.com/finance/getprices?'
  url = "i={0}&p={1}d&f=d,o,h,l,c,v&df=cpct&q={2}&x=NSE".format(tf,tp,symbol)
  ep_time_stamp = 0

  req = requests.get(baseurl+url)

  if (req.status_code):
    histDt = list(req.text.splitlines())

    tf_offset = int((histDt[6].split('='))[1])
    print(tf_offset)

  for r in range(7,len(histDt)-1):
    if re.match('^a',histDt[r]):
      rec = histDt[r].split(',')
      ep_ts = int(rec[0][1:len(rec[0])])+(tf_offset*60)
      print(ep_ts)
      ep_time_stamp = ep_ts
      time_stamp = time.strftime("%d%m%y-%w-%H:%M:%S", (time.localtime(ep_time_stamp)))
      rec[0] = time_stamp
      #print(rec)
      histData.append(rec)
    else:
      rec = histDt[r].split(',')
      time_stamp = time.strftime("%d%m%y-%w-%H:%M:%S",(time.localtime(ep_time_stamp+(int(rec[0])*int(tf)))))
      rec[0] = time_stamp
      #print(rec)
      histData.append(rec)

def saveToFile(data):
  with open('BHARTIARTL_5min_5days.csv','w') as histFile:
    wr = csv.writer(histFile, quoting=csv.QUOTE_ALL)
    wr.writerow(data)



    

getHistData(300,5,'BHARTIARTL')

print(histData)
saveToFile(histData)

