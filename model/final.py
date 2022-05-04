# -*- coding: utf-8 -*-
import requests
import pandas as pd
import math
from tqdm import tqdm
import yfinance as yf
import exchange_calendars as ecals

from bs4 import BeautifulSoup
import re
import time
import itertools
import csv
import datetime
import schedule
import konlpy
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

#기존 트레이닝 데이터 학습
train_data = pd.read_csv("./train.csv")

stopwords = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']

okt = Okt()
X_train = []
for sentence in train_data['title']:
  temp_X =[]
  temp_X = okt.morphs(str(sentence), stem=True) #토큰화
  temp_X = [word for word in temp_X if not word in stopwords] #안쓰는 말 제거
  X_train.append(temp_X)
  
max_words = 35000
tokenizer = Tokenizer(num_words = max_words)
tokenizer.fit_on_texts(X_train)
X_train = tokenizer.texts_to_sequences(X_train)

y_train = []
for i in range(len(train_data['label'])):
  if train_data['label'].iloc[i]==1:
    y_train.append([0,0,1])
  elif train_data['label'].iloc[i]==0:
     y_train.append([0,1,0]) 
  elif train_data['label'].iloc[i]== -1:
     y_train.append([1,0,0])
y_train = np.array(y_train) 

max_len = 20
X_train = pad_sequences(X_train, maxlen=max_len)
model = Sequential()
model.add(Embedding(max_words, 100))
model.add(LSTM(128))
model.add(Dense(3, activation = 'softmax'))
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics = ['accuracy'])
history = model.fit(X_train, y_train, epochs=10, batch_size=10, validation_split=0.1)

# 쿼링 보낼 database
cred = credentials.Certificate('./firebase_key.json')
firebase_admin.initialize_app(cred, {
  'projectId': 'capstone-2022-07-dac76',
})

db = firestore.client()
 

# 공공데이터포털 api 주소(Without param)
url_stock = "http://api.seibro.or.kr/openapi/service/StockSvc/getKDRSecnInfo"  
api_service_key_stock = [
    "RXhGWArdgsytKaKf0g%2FWxNuo27wXxg4iChLUs9ePc39VvneddFbQ9v9ZXCDWJkdFbhqCvbw9kdMGy%2F%2Bv3it50A%3D%3D",
    "bqvyeN8k%2B8%2BfRLf7p4CNQsUIEL%2BRb4b2YR08MD10RDv3BxHugq6bR1wFEAo8hTau3XgiLcA7bEBoclnMdyBfNQ%3D%3D",
    "zUgkw3obrruAXAW6kZrJnIpK8UUBIrwXrfroSgoDS7NUlSB%2BDz94OTIkkWeP0V%2BzOz81JVtW84bqh1y0HpzcUg%3D%3D",
    "w9Ra19Zqn3%2BLgg2zHoRiZa8zZPdSCXSgFgrgFGUkaYqqQRD6BVKMsUgiRyJqeEuG1pQ86vSioq03IRarAve7sg%3D%3D",
]  # service api key

# 종목 이름 가져오는 코드
def getStockCode(market, url_param):
    """
    market: 상장구분 (11=유가증권, 12=코스닥, 13=K-OTC, 14=코넥스, 50=기타비상장)
    """
    url_base = f"http://api.seibro.or.kr/openapi/service/{url_param}"
    url_spec = "getShotnByMartN1"
    url = url_base + "/" + url_spec
    stock_code = 0
    while True:
        api_decode_key_stock = requests.utils.unquote(
            api_service_key_stock[stock_code], encoding="utf-8"
        )

        params = {
            "serviceKey": api_decode_key_stock,
            "pageNo": 1,
            "numOfRows": 100000,
            "martTpcd": market,
        }

        response = requests.get(url, params=params)
        # print(response.text)
        xml = BeautifulSoup(response.text, "lxml")
        items = xml.find("items")
        item_list = []
        try:
            for item in items:
                item_list.append(item.find("korsecnnm").text.strip())
        except TypeError:
            stock_code += 1
            continue

        return item_list


# 기사 제목 전처리 함수
def text_clean(inputString):
    # inputString = inputString.replace("<b>","").replace("</b>","") # html 태그 제거  ## <b> <b/>
    inputString = re.sub(r'\<[^)]*\>', '', inputString, 0).strip() # <> 안의 내용 제거  ## html태그 + 종목명
    inputString = re.sub('[-=+,#/\?:^.@*\"※~ㆍ!』‘|\(\)\[\]`\'…》\”\“\’·]', ' ', inputString) # 특수문자 제거
    inputString = inputString.replace("&quot;"," ").replace("amp;","").replace("&gt; "," ").replace("&lt;"," ")
    inputString = ' '.join(inputString.split())
    
    return inputString

# 기사 날짜 전처리 함수
def formatting_date(date):
    format ='%a, %d %b %Y %H:%M:%S %z'
    date = datetime.datetime.strptime(date, format) # str to datetime
    date = date.strftime("%Y-%m-%d %H:%M:%S") # changing datetime format
    
    return date

# Naver client key
client_id= "4NnYXQRzNVwTEO2_rwpd"
client_secret = "mZP8JBDOBK"

# Naver clint key by sj
# client_id = "8Sbpzhlz4LPc0MPsiaOO"
# client_secret = "HPqxX8HZfG"

# 네이버 api 함수
def api_search(tuple_list, stock):
    url = 'https://openapi.naver.com/v1/search/news.json' 
    header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
    param = {'query':stock, 'display':100, 'start':1, 'sort':'date'} 
    # query     : 검색할 단어
    # display   : 검색 출력 건수 (기본 10 / 최대 100)
    # start     : 검색 시작 위치 (기본 1  / 최대 1000)
    # sort      : 정렬순서      (기본 sim : 유사도 / date : 날짜)
    res = requests.get(url, params=param, headers=header)

    pov_or_neg = 0 #긍부정 라벨링 값

    if res.status_code == 200:
        temp = res.json()

        # for index, item in enumerate(temp['items']):
        #     print(index+1, item['title'], item['link'], item['description'],item['pubDate'])

        # TODO
        for index, dict in enumerate(temp['items']):
            title  = text_clean(dict['title'])

            #학습데이터를 통해서 라벨링
            X_test=[]
            temp_X = okt.morphs(str(title), stem=True) #토큰화
            temp_X = [word for word in temp_X if not word in stopwords] #안쓰는 말 제거
            X_test.append(temp_X)
            X_test = tokenizer.texts_to_sequences(X_test)
            predict= model.predict(X_test)
            # 호악재 예측값 저장
            pov_or_neg = np.argmax(predict,axis=1)[0]

            date = formatting_date(dict['pubDate'])

            # 쿼링 코드
            
            news_temp = db.collection(u'stock').document(stock).collection(u'news').document(str(index+1))
            news_temp.set({
                u'date': date,
                u'title': title,
                u'label': str(pov_or_neg),
                u'url':dict[str('originallink')]
            })
            
            tuple_list.append((stock ,title ,dict['originallink'] ,date ,pov_or_neg))
                # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
    else:
        print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))


# 종목들 전역변수로 가져오기
company=[]
def get_companylist():
    temp = list()
    temp.append(getStockCode(11, "StockSvc"))
    temp.append(getStockCode(12, "StockSvc"))
    global company
    company = list(itertools.chain.from_iterable(temp))

def run(reset):
    # 계산된 횟수만 실행
    print("run")
    while reset:
        print("남은횟수: ", reset)
        start = time.time()
        tuple_list=[]
        tuple_list.append(("stock" ,"title" ,"url" ,"date" ,"pov_or_neg"))
        num = len(company)
        count=0
        tmp_time = time.time()
        for i in range(num):
            api_search(tuple_list, company[i])
            count+=1    
            #api는 초당 10개라서 딜레이를 주었음
            if count==10:
                time_10 = time.time()-tmp_time
                take_a_nap = 1-time_10 if  0 < (time_10) and (time_10) < 1 else 0
                time.sleep(take_a_nap)
                count=0
                tmp_time=time.time()

        # 쿼링 포함 15분 제한
        end = time.time()
        rest_time = 900 - (end-start)
        time.sleep(rest_time) 

        reset -= 1

    



    # #tuple to csv 저장
    # with open('news.csv', 'w') as f:
    #     writer = csv.writer(f , lineterminator='\n')
    #     for tup in tuple_list:
    #         writer.writerow(tup)


# 8시 20분에 주식가져옴
schedule.every().day.at("08:20").do(get_companylist)
# 8시 30분에 코드 실행
schedule.every().day.at("08:30").do(run)


if __name__ == "__main__":
    print("start")
    # 주식 종목을 global로 설정
    get_companylist()
    now = datetime.datetime.now()
    time_now = datetime.timedelta(hours= now.hour , minutes=now.minute)
    time_start = datetime.timedelta(hours= 8, minutes=30)
    time_end = datetime.timedelta(hours= 16, minutes=00)
    #시간 계산해서 장 중일 때만 작동하도록..
    if (time_now > time_start) and (time_end > time_now):
        time_diff_s = (time_end-time_now).total_seconds()
        time_diff_m = time_diff_s/60
        run_time = int(time_diff_m/15)

        run(run_time)
    while True:
        schedule.run_pending()
        time.sleep(1)

#시간제한없는거랑
#중복제거
#어떤 형식으로 나오는지 csv만들고
#쿼링