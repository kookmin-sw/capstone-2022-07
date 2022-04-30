# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
import re
import time
import itertools
import csv
import datetime
import schedule
import pandas as pd
import konlpy
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer

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
last_title=dict()


# 네이버 api 함수
def api_search(tuple_list, stock):
    url = 'https://openapi.naver.com/v1/search/news.json' 
    header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
    param = {'query':stock, 'display':1, 'start':1, 'sort':'date'} 
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
        title_temp = temp['items'][0]['title']
        for dict in temp['items']:
            title  = text_clean(dict['title'])

            if stock not in last_title:
                last_title[stock] = title

            end_point = last_title[stock]
            while(end_point != title):
                #학습데이터를 통해서 라벨링
                temp_title = okt.morphs(str(title), stem=True)
                temp_title = [word for word in temp_title if not word in stopwords]
                temp_title = tokenizer.texts_to_sequences(temp_title)
                
                predict = model.predict(temp_title)
                predict_labels = np.argmax(predict, axis=1)
                pov_or_neg = predict_labels

                date = formatting_date(dict['pubDate'])
                tuple_list.append((stock ,title ,dict['originallink'] ,date ,pov_or_neg))
                # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
        last_title[stock]=title_temp
    else:
        print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))



company=[]
def get_companylist():
    temp = list()
    temp.append(getStockCode(11, "StockSvc"))
    temp.append(getStockCode(12, "StockSvc"))
    global company
    company = list(itertools.chain.from_iterable(temp))

def run():
    try:
        # 8시 30분부터 7시간 동안 15분 주기로 
        print("run")
        reset = 7*4 # 15분씩 4번 7시간
        while reset:
            print("남은횟수: ", reset)
            start = time.time()
            tuple_list=[]
            tuple_list.append(("stock" ,"title" ,"url" ,"date" ,"pov_or_neg"))
            num = len(company)
            count=0
            for i in range(num):
                api_search(tuple_list, company[i])
                count+=1    
                #api는 초당 10개라서 10개당 0.5초씩 딜레이 
                if count==10:
                    count=0
                    time.sleep(0.5)

            end = time.time()
            rest_time = 900 - (end-start)
            time.sleep(rest_time) # 15분 휴식

            reset -= 1

    except ValueError:
        print("valueERR")
        print(time.time()-start)



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
    get_companylist()
    now = datetime.datetime.now()
    time_now = datetime.timedelta(hours= now.hour , minutes=now.minute)
    time_start = datetime.timedelta(hours= 8, minutes=30)
    time_end = datetime.timedelta(hours= 17, minutes=30)
    #만약 장 중 이라면
    if (time_now > time_start) and (time_end > time_now):
        run()
    while True:
        schedule.run_pending()
        time.sleep(1)

#시간제한없는거랑
#중복제거
#어떤 형식으로 나오는지 csv만들고
#쿼링