from bs4 import BeautifulSoup
import requests
import re
import time
import itertools
import csv
import datetime
import schedule
import datetime

def text_clean(inputString):
    # inputString = inputString.replace("<b>","").replace("</b>","") # html 태그 제거  ## <b> <b/>
    inputString = re.sub(r'\<[^)]*\>', '', inputString, 0).strip() # <> 안의 내용 제거  ## html태그 + 종목명
    inputString = re.sub('[-=+,#/\?:^.@*\"※~ㆍ!』‘|\(\)\[\]`\'…》\”\“\’·]', ' ', inputString) # 특수문자 제거
    inputString = inputString.replace("&quot;"," ").replace("amp;","").replace("&gt; "," ").replace("&lt;"," ")
    inputString = ' '.join(inputString.split())
    
    return inputString
def formatting_date(date):
    format ='%a, %d %b %Y %H:%M:%S %z'
    date = datetime.datetime.strptime(date, format) # str to datetime
    date = date.strftime("%Y-%m-%d %H:%M:%S") # changing datetime format
    
    return date

client_id= "4NnYXQRzNVwTEO2_rwpd"
client_secret = "mZP8JBDOBK"

stock = '카카오'

url = 'https://openapi.naver.com/v1/search/news.json' 
header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
param = {'query':stock, 'display':10, 'start':1, 'sort':'date'} 

res = requests.get(url, params=param, headers=header)

last_title=dict()
print(res)
if res.status_code == 200:
    temp = res.json()
    print(temp)
    
    for dict in temp['items']:
        title  = text_clean(dict['title'])

        if stock not in last_title:
            last_title['stock'] = title

        end_point = last_title['stock']
        print(end_point)
        while(end_point != title):
            date = formatting_date(dict['pubDate'])
            pov_or_neg = 0

            print((stock ,title ,dict['originallink'] ,dict['pubDate'] ,pov_or_neg))
            # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
else:
    print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))

print("fi")