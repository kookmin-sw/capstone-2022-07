# -*- coding: utf-8 -*-
#import
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
#firebase 관련
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

#기존 트레이닝 데이터 학습
train_data = pd.read_csv("./train.csv")
stopwords = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']
#형태소분석
okt = Okt()
X_train = []
for sentence in train_data['title']:
  temp_X =[]
  temp_X = okt.morphs(str(sentence), stem=True) #토큰화
  temp_X = [word for word in temp_X if not word in stopwords] #안쓰는 말 제거
  X_train.append(temp_X)
max_words = 35000
#토큰화
tokenizer = Tokenizer(num_words = max_words)
tokenizer.fit_on_texts(X_train)
X_train = tokenizer.texts_to_sequences(X_train)
#정규화
y_train = []
for i in range(len(train_data['label'])):
  if train_data['label'].iloc[i]==1:
    y_train.append([0,0,1])
  elif train_data['label'].iloc[i]==0:
     y_train.append([0,1,0]) 
  elif train_data['label'].iloc[i]== -1:
     y_train.append([1,0,0])
y_train = np.array(y_train) 
#학습
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
def getStockCode(market, code_list):
    """
    market: 상장구분 (11=유가증권, 12=코스닥, 13=K-OTC, 14=코넥스, 50=기타비상장)
    """
    url = f"https://api.odcloud.kr/api/GetStockSecuritiesInfoService/v1/getStockPriceInfo?"
    stock_code = 0
    while True:
        api_decode_key_stock = requests.utils.unquote(
            api_service_key_stock[stock_code], encoding="utf-8"
        )

        params = {
            "serviceKey": api_decode_key_stock,
            "mrktCls": market,
            "numOfRows": 1000,
            "beginBasDt":pre_previous.replace("-", "")
        }

        response = requests.get(url, params=params)
        if(response.status_code != 200):
            print(response.status_code)
            stock_code += 1
            continue
        xml = BeautifulSoup(response.text, "lxml")
        items = xml.find("items")
        item_list = []
        for item in items:
            try:
                item_dict = {
                    "stockName": item.find("itmsnm").text.strip(),
                    "stockCode": item.find("srtncd").text.strip(),
                    "marketCap": item.find("mrkttotamt").text.strip(),
                }
                code_list.append(item.find("srtncd").text.strip() + ".KS")
            except AttributeError:
                continue
            item_list.append(item_dict)

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
    param = {'query':stock, 'display':3, 'start':1, 'sort':'date'} 
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
            tokenizer = Tokenizer(num_words = 35000)
            tokenizer.fit_on_texts(X_test)
            X_test = tokenizer.texts_to_sequences(X_test)
            X_test = pad_sequences(X_test, maxlen=max_len)
            predict= model.predict(X_test)
            # 호악재 예측값 저장
            pov_or_neg = np.argmax(predict,axis=1)[0]
            date = formatting_date(dict['pubDate'])
            # 쿼링 코드
            news_temp = db.collection(u'merge').document(stock).collection(u'news').document(str(index+1))
            news_temp.set({
                u'date': date,
                u'title': title,
                u'label': str(pov_or_neg),
                u'url':dict[str('originallink')],
            })
            
            tuple_list.append((stock ,title ,dict['originallink'] ,date ,pov_or_neg))
                # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
    else:
        print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))


# 종목들 전역변수로 가져오기
company=[]
def get_companylist():
    #날짜반영
    XKRX = ecals.get_calendar("XKRX") # 한국 코드
    current = datetime.datetime.now()
    corr_current = current - datetime.timedelta(hours=9)
    global pre_previous
    global time_previous
    global previous
    if(XKRX.is_trading_minute(corr_current.strftime("%Y-%m-%d %H:%M"))):
        previous = datetime.date.today().strftime("%Y-%m-%d")
        time_previous = datetime.date.today().strftime("%Y-%m-%d %H:%M")
        pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
    else:
        previous = XKRX.previous_minute(corr_current.strftime("%Y-%m-%d %H:%M")).strftime("%Y-%m-%d")
        time_previous = XKRX.previous_minute(corr_current.strftime("%Y-%m-%d %H:%M")) + datetime.timedelta(hours=9)
        pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
        time_previous = str(time_previous.strftime("%Y-%m-%d %H:%M"))
    #temp = list()
    #temp.append(getStockCode(11, "StockSvc"))
    global code_list
    code_list = []
    item_list = getStockCode("KOSPI", code_list)
    item_list.append({
        "stockName": "코스피",
        "stockCode": "^KS11",
        "marketCap": 0,
        "updatedTime" : time_previous,
        })
    item_list.append({
        "stockName": "코스닥",
        "stockCode": "^KQ11",
        "marketCap": 0,
    })
    code_list.append("^KS11")
    code_list.append("^KQ11")
    global company
    company=item_list

def stock_information():
    # 여기서부터는 시간별로 실행 - 실시간 코드
    # start에는 장이 열리는 날 - 하루가 들어가야 함
    data = yf.download(code_list, start=pre_previous)

    # item_list에 각 필드들 쿼링
    for j in tqdm(company):
        stockCode = j["stockCode"]
        if j["stockCode"] != "^KS11" and j["stockCode"] != "^KQ11" :
            stockCode += ".KS"
            
        j["stockPrice"] = float(data["Close"][stockCode][previous])
        j["stockLowPrice"] = float(data["Low"][stockCode][previous])
        j["stockHighPrice"] = float(data["High"][stockCode][previous])
        j["stockVolume"] = float(data["Volume"][stockCode][previous])
        j["stockOpenPrice"] = float(data["Open"][stockCode][previous])
        j["stockClosingPrice"] = float(data["Close"][stockCode][pre_previous])
        j['stockChange'] = float(data['Close'][stockCode][previous] - data['Close'][stockCode][pre_previous])
        j['stockPerChange'] = float((data['Close'][stockCode][previous] - data['Close'][stockCode][pre_previous]) / data['Close'][stockCode][pre_previous] * 100)
        j['DayNewsCount'] = 0
        j['TimeNewsCount'] = 0
        j["TimePerPositiveNewsCount"] = 0
        j["TimePerNegativeNewsCount"] = 0

    # 상장폐지 / 거래중지 종목 리스트에서 제거
    for i in company:
        if math.isnan(i['stockPrice']) or math.isnan(i['stockLowPrice']) or math.isnan(i['stockHighPrice']) or math.isnan(i['stockVolume']) or math.isnan(i['stockOpenPrice'])or math.isnan(i['stockClosingPrice'])or math.isnan(i['stockChange'])or math.isnan(i['stockPerChange']):
            company.remove(i)

    # round 처리로 2자리수까지 보여짐
    # nan 처리 해주고 나서 돌려야해서 필요한 코드
    for j in tqdm(company):
        stockCode = j["stockCode"]
        if j["stockCode"] != "^KS11" and j["stockCode"] != "^KQ11" :
            stockCode += ".KS"
        j["stockPrice"] = float(round(data["Close"][stockCode][previous], 2))
        j["stockLowPrice"] = float(round(data["Low"][stockCode][previous], 2))
        j["stockHighPrice"] = float(round(data["High"][stockCode][previous], 2))
        j["stockVolume"] = float(round(data["Volume"][stockCode][previous], 2))
        j["stockOpenPrice"] = float(round(data["Open"][stockCode][previous], 2))
        j["stockClosingPrice"] = float(round(data["Close"][stockCode][pre_previous], 2))
        j['stockChange'] = float(round(data['Close'][stockCode][previous] - data['Close'][stockCode][pre_previous], 2))
        j['stockPerChange'] = float(round((data['Close'][stockCode][previous] - data['Close'][stockCode][pre_previous]) / data['Close'][stockCode][pre_previous] * 100, 2))


    db = firestore.client()

    from multiprocessing.dummy import Pool as ThreadPool
    def AddFirebase(item):
        db.collection(u"merge").document(item["stockName"]).set(item)

    pool = ThreadPool(10)

    for _ in tqdm(pool.imap_unordered(AddFirebase, company), total=len(company)):
        pass

    pool.close() 
    pool.join()
    
    
    

def run(reset):
    # 계산된 횟수만 실행
    print("run")
    stock_information()
    while reset:
        get_companylist()
        print("남은횟수: ", reset)
        start = time.time()
        tuple_list=[]
        tuple_list.append(("stock" ,"title" ,"url" ,"date" ,"pov_or_neg"))
        num = len(company)
        count=0
        tmp_time = time.time()
        for stock in tqdm(company):
            api_search(tuple_list, stock["stockName"])
            '''
            count+=1
            #api는 초당 10개라서 딜레이를 주었음
            if count==10:
                time_10 = time.time()-tmp_time
                take_a_nap = 1-time_10 if  0 < (time_10) and (time_10) < 1 else 0
                time.sleep(take_a_nap)
                count=0
                tmp_time=time.time()
            '''
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
    time_end = datetime.timedelta(hours= 20, minutes=00)
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