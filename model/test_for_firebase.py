from bs4 import BeautifulSoup
import requests
import re
import time
import itertools
import csv
import datetime

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

cred = credentials.Certificate('./firebase_key.json')
firebase_admin.initialize_app(cred, {
  'projectId': 'capstone-2022-07-dac76',
})

db = firestore.client()

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


client_id = "8Sbpzhlz4LPc0MPsiaOO"
client_secret = "HPqxX8HZfG"
stock = '카카오'
url = 'https://openapi.naver.com/v1/search/news.json' 
header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
param = {'query':stock, 'display':5, 'start':1, 'sort':'date'} 
# query     : 검색할 단어
# display   : 검색 출력 건수 (기본 10 / 최대 100)
# start     : 검색 시작 위치 (기본 1  / 최대 1000)
# sort      : 정렬순서      (기본 sim : 유사도 / date : 날짜)
res = requests.get(url, params=param, headers=header)
stopwords = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']
stocks = ["삼성전자","카카오","sk하이닉스","lg디스플레이"]

pov_or_neg = 0 #긍부정 라벨링 값
for stock in stocks:
    url = 'https://openapi.naver.com/v1/search/news.json' 
    header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
    param = {'query':stock, 'display':10, 'start':1, 'sort':'date'} 
    res = requests.get(url, params=param, headers=header)
    tuple_list=[]
    if res.status_code == 200:
        temp = res.json()

        # for index, item in enumerate(temp['items']):
        #     print(index+1, item['title'], item['link'], item['description'],item['pubDate'])

        # TODO
        index=0
        for dict in temp['items']:
            title  = text_clean(dict['title'])
            date = formatting_date(dict['pubDate'])
            # 쿼링을 여기서 줘야겠죠..??
            # X_test=[]
            # temp_X = okt.morphs(str(title), stem=True) #토큰화
            # temp_X = [word for word in temp_X if not word in stopwords] #안쓰는 말 제거
            # X_test.append(temp_X)
            # X_test = tokenizer.texts_to_sequences(X_test)
            print(str(index+1))

            news_temp = db.collection(u'test_승준').document(stock).collection(u'news').document(str(index+1))

            news_temp.set({
                u'date': date,
                u'title': title,
                u'label': pov_or_neg,
                u'url':dict['originallink']
            })

            # tuple_list.append((stock ,title ,dict['originallink'] ,date ,pov_or_neg))
                # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
    else:
        print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))


# news_temp = db.collection(u'stock').document(u'카카오').collection(u'news').document(u'temp3')
# news_temp.set({
#     u'date': "2022.01.19",
#     u'title': "이승준, 쿼링에 성공해..",
#     u'label': 1,
#     u'url':"대충뉴스유알엘.com"
# })
# '''
# stock_temp = db.collection(u'stock').document(u'카카오')
# stock_temp.set({
#     u'code': '0019321',
#     u'name': "카카오",
#     u'price': "91000",
# })
# '''