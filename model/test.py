# -*- coding: utf-8 -*-
# import
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
from multiprocessing.dummy import Pool as ThreadPool
import schedule
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer

# firebase 관련
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

# 멀티프로세싱
import multiprocessing
from multiprocessing import Manager, Pool, freeze_support

# warning 문자 무시
import warnings

warnings.filterwarnings("ignore")

train_data = pd.read_csv("./train.csv")
stopwords = [
    "의",
    "가",
    "이",
    "은",
    "들",
    "는",
    "좀",
    "잘",
    "걍",
    "과",
    "도",
    "를",
    "으로",
    "자",
    "에",
    "와",
    "한",
    "하다",
]
del_list = [
    "오늘의",
    "뉴스",
    "급락주",
    "마감",
    "주요",
    "급등주",
    "증시일정",
    "캘린더",
    "이번주",
    "[포토]",
    "[인사]",
    "상장사",
    "주간",
    "종목",
    "총정리",
    "다음주",
    "슈퍼주총",
    "공모주",
    "돋보기",
    "週間",
    "증권주",
    "코스피",
    "코스닥",
    "KOSPI",
    "KOSDAQ",
]

# 형태소분석
JVM_PATH = "/Library/Java/JavaVirtualMachines/zulu-15.jdk/Contents/Home/bin/java"
okt = Okt(jvmpath=JVM_PATH)
X_train = []
for sentence in train_data["title"]:
    temp_X = []
    temp_X = okt.morphs(str(sentence), stem=True)  # 토큰화
    temp_X = [word for word in temp_X if not word in stopwords]  # 안쓰는 말 제거
    X_train.append(temp_X)
max_words = 35000
# 토큰화
tokenizer = Tokenizer(num_words=max_words)
tokenizer.fit_on_texts(X_train)
X_train = tokenizer.texts_to_sequences(X_train)
# 정규화
y_train = []
for i in range(len(train_data["label"])):
    if train_data["label"].iloc[i] == 1:
        y_train.append([0, 0, 1])
    elif train_data["label"].iloc[i] == 0:
        y_train.append([0, 1, 0])
    elif train_data["label"].iloc[i] == -1:
        y_train.append([1, 0, 0])
y_train = np.array(y_train)
# 학습
max_len = 20
X_train = pad_sequences(X_train, maxlen=max_len)
model = Sequential()
model.add(Embedding(max_words, 100))
model.add(LSTM(128))
model.add(Dense(3, activation="softmax"))
model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
history = model.fit(X_train, y_train, epochs=10, batch_size=10, validation_split=0.1)

# 쿼링 보낼 database
cred = credentials.Certificate("./firebase_key.json")
firebase_admin.initialize_app(
    cred,
    {
        "projectId": "capstone-2022-07-dac76",
    },
)

db = firestore.client()

XKRX = ecals.get_calendar("XKRX")  # 한국 코드
current = datetime.datetime.now()
corr_current = current - datetime.timedelta(hours=9)
global pre_previous
global time_previous
global previous
if XKRX.is_trading_minute(corr_current.strftime("%Y-%m-%d %H:%M")):
    previous = datetime.date.today().strftime("%Y-%m-%d")
    time_previous = datetime.date.today().strftime("%Y-%m-%d %H:%M")
    pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
else:
    previous = XKRX.previous_minute(corr_current.strftime("%Y-%m-%d %H:%M")).strftime(
        "%Y-%m-%d"
    )
    time_previous = XKRX.previous_minute(
        corr_current.strftime("%Y-%m-%d %H:%M")
    ) + datetime.timedelta(hours=9)
    pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
    time_previous = str(time_previous.strftime("%Y-%m-%d %H:%M"))

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
            "beginBasDt": pre_previous.replace("-", ""),
        }

        response = requests.get(url, params=params)
        if response.status_code != 200:
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


def text_clean(inputString):
    # inputString = inputString.replace("<b>","").replace("</b>","") # html 태그 제거  ## <b> <b/>
    inputString = re.sub(
        r"\<[^)]*\>", "", inputString, 0
    ).strip()  # <> 안의 내용 제거  ## html태그 + 종목명
    inputString = re.sub(
        "[-=+,#/\?:^.@*\"※~ㆍ!』‘|\(\)\[\]`'…》\”\“\’·]", " ", inputString
    )  # 특수문자 제거
    inputString = (
        inputString.replace("&quot;", " ")
        .replace("amp;", "")
        .replace("&gt; ", " ")
        .replace("&lt;", " ")
    )
    inputString = " ".join(inputString.split())

    return inputString


# 기사 날짜 전처리 함수
def formatting_date(date):
    format = "%a, %d %b %Y %H:%M:%S %z"
    date = datetime.datetime.strptime(date, format)  # str to datetime
    date = date.strftime("%Y-%m-%d %H:%M:%S")  # changing datetime format

    return date


# 날짜 -> timestamp = 뉴스의 중복 제거를 위함
def time_to_stamp(date):
    date = date.replace("0900", "0000")
    format = "%a, %d %b %Y %H:%M:%S %z"
    date = datetime.datetime.strptime(date, format)  # str to datetime

    return date


# Naver client key
Naver_client_id = ["4NnYXQRzNVwTEO2_rwpd", "8Sbpzhlz4LPc0MPsiaOO"]
Naver_client_secret = ["mZP8JBDOBK", "HPqxX8HZfG"]

temp_dt = "Thu, 01 Mar 2022 06:02:00 +0900"
format = "%a, %d %b %Y %H:%M:%S %z"
temp_dt = datetime.datetime.strptime(temp_dt, format)  # str to datetime

# 네이버 api 함수
def api_search(tuple_list, stock, id_key):
    url = "https://openapi.naver.com/v1/search/news.json"
    header = {
        "X-Naver-Client-Id": Naver_client_id[id_key],
        "X-Naver-Client-Secret": Naver_client_secret[id_key],
    }
    param = {"query": stock, "display": 20, "start": 1, "sort": "date"}
    # query     : 검색할 단어
    # display   : 검색 출력 건수 (기본 10 / 최대 100)
    # start     : 검색 시작 위치 (기본 1  / 최대 1000)
    # sort      : 정렬순서      (기본 sim : 유사도 / date : 날짜)
    res = requests.get(url, params=param, headers=header)

    pov_or_neg = 0  # 긍부정 라벨링 값

    if res.status_code == 200:
        temp = res.json()

        ## 파베에서 제일 최근 기사 time stamp 불러오기
        docs = (
            db.collection("stock")
            .document(stock)
            .collection("news")
            .where("timestamp", ">", temp_dt)
            .order_by("timestamp", direction=firestore.Query.DESCENDING)
            .limit(1)
            .stream()
        )
        bb = {}
        for doc in docs:
            bb = doc.to_dict()
        endPoint = bb["timestamp"] if len(bb) > 0 else temp_dt

        stock_news_list = []

        for index, dict in tqdm(enumerate(temp["items"])):
            news_timestamp = time_to_stamp(dict["pubDate"])
            if endPoint > news_timestamp:
                break

            title = text_clean(dict["title"])

            # 학습데이터를 통해서 라벨링
            X_test = []
            temp_X = okt.morphs(str(title), stem=True)  # 토큰화
            temp_X = [word for word in temp_X if not word in stopwords]  # 안쓰는 말 제거
            X_test.append(temp_X)
            tokenizer = Tokenizer(num_words=35000)
            tokenizer.fit_on_texts(X_test)
            X_test = tokenizer.texts_to_sequences(X_test)
            X_test = pad_sequences(X_test, maxlen=max_len)
            predict = model.predict(X_test)
            # 호악재 예측값 저장
            pov_or_neg = np.argmax(predict, axis=1)[0]

            date = formatting_date(dict["pubDate"])

            stock_news_list.append(
                {
                    "date": date,
                    "title": title,
                    "label": str(pov_or_neg),
                    "url": dict[str("originallink")],
                    "timestamp": news_timestamp,
                }
            )

            tuple_list.append((stock, title, dict["originallink"], date, pov_or_neg))
            # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
    else:
        print("Error Code:" + str(res.status_code) + " Stock name is " + str(stock))

    def AddFirebaseToNews(item):
        db.collection("stock").document(stock).collection("news").document().set(item)

    pool = ThreadPool(10)

    for _ in tqdm(
        pool.imap_unordered(AddFirebaseToNews, stock_news_list),
        total=len(stock_news_list),
    ):
        pass

    ## 개수 카운트
    time_hour = datetime.datetime.now() - datetime.timedelta(hours=1)
    docs = (
        db.collection("stock")
        .document(stock)
        .collection("news")
        .where("timestamp", ">", time_hour)
        .stream()
    )

    TimeNewsCount = 0  # 시간당 기사 개수
    TimePerPositiveNewsCount = 0  # 시간당긍정개수
    TimePerNegativeNewsCount = 0  # 시간당부정개수
    DayNewsCount = 0  # 하루 기사 개수
    bb = {}
    for doc in docs:
        TimeNewsCount += 1
        bb = doc.to_dict()
        if bb["label"] == "0":
            TimePerNegativeNewsCount += 1
        elif bb["label"] == "2":
            TimePerPositiveNewsCount += 1

    time_day = datetime.datetime.now() - datetime.timedelta(days=1)
    docs = (
        db.collection("stock")
        .document(stock)
        .collection("news")
        .where("timestamp", ">", time_day)
        .stream()
    )
    bb = {}
    for doc in docs:
        DayNewsCount += 1

    news_temp = db.collection("stock").document(stock)
    news_temp.update(
        {
            "DayNewsCount": DayNewsCount,
            "TimeNewsCount": TimeNewsCount,
            "TimePerPositiveNewsCount": TimePerPositiveNewsCount,
            "TimePerNegativeNewsCount": TimePerNegativeNewsCount,
        }
    )


# 종목들 전역변수로 가져오기
company = []


def get_companylist():
    global code_list
    code_list = []
    item_list = getStockCode("KOSPI", code_list)
    item_list.append(
        {
            "stockName": "코스피",
            "stockCode": "^KS11",
            "marketCap": 0,
            "updatedTime": time_previous,
        }
    )
    item_list.append(
        {
            "stockName": "코스닥",
            "stockCode": "^KQ11",
            "marketCap": 0,
        }
    )
    code_list.append("^KS11")
    code_list.append("^KQ11")
    global company
    company = item_list


def stock_information_getTime():
    # start에는 장이 열리는 날 - 하루가 들어가야 함
    # 날짜반영
    XKRX = ecals.get_calendar("XKRX")  # 한국 코드
    current = datetime.datetime.now()
    corr_current = current - datetime.timedelta(hours=9)
    global pre_previous
    global time_previous
    global previous
    if XKRX.is_trading_minute(corr_current.strftime("%Y-%m-%d %H:%M")):
        previous = datetime.date.today().strftime("%Y-%m-%d")
        time_previous = datetime.date.today().strftime("%Y-%m-%d %H:%M")
        pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
    else:
        previous = XKRX.previous_minute(
            corr_current.strftime("%Y-%m-%d %H:%M")
        ).strftime("%Y-%m-%d")
        time_previous = XKRX.previous_minute(
            corr_current.strftime("%Y-%m-%d %H:%M")
        ) + datetime.timedelta(hours=9)
        pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
        time_previous = str(time_previous.strftime("%Y-%m-%d %H:%M"))


stock_information_getTime()


def stock_pretreatment():
    data = yf.download(code_list, start=pre_previous)
    # item_list에 각 필드들 쿼링
    for j in tqdm(company):
        stockCode = j["stockCode"]
        if j["stockCode"] != "^KS11" and j["stockCode"] != "^KQ11":
            stockCode += ".KS"
        j["stockPrice"] = float(data["Close"][stockCode][1])
        j["stockLowPrice"] = float(data["Low"][stockCode][1])
        j["stockHighPrice"] = float(data["High"][stockCode][1])
        j["stockVolume"] = float(data["Volume"][stockCode][1])
        j["stockOpenPrice"] = float(data["Open"][stockCode][1])
        j["stockClosingPrice"] = float(data["Close"][stockCode][0])
        j["stockChange"] = float(
            data["Close"][stockCode][1] - data["Close"][stockCode][0]
        )
        j["stockPerChange"] = float(
            (data["Close"][stockCode][1] - data["Close"][stockCode][0])
            / data["Close"][stockCode][0]
            * 100
        )

    # 상장폐지 / 거래중지 종목 리스트에서 제거
    for i in company:
        if (
            math.isnan(i["stockPrice"])
            or math.isnan(i["stockLowPrice"])
            or math.isnan(i["stockHighPrice"])
            or math.isnan(i["stockVolume"])
            or math.isnan(i["stockOpenPrice"])
            or math.isnan(i["stockClosingPrice"])
            or math.isnan(i["stockChange"])
            or math.isnan(i["stockPerChange"])
        ):
            company.remove(i)

    # round 처리로 2자리수까지 보여짐
    # nan 처리 해주고 나서 돌려야해서 필요한 코드
    for j in tqdm(company):
        stockCode = j["stockCode"]
        if j["stockCode"] != "^KS11" and j["stockCode"] != "^KQ11":
            stockCode += ".KS"
        j["stockPrice"] = float(round(data["Close"][stockCode][1], 2))
        j["stockLowPrice"] = float(round(data["Low"][stockCode][1], 2))
        j["stockHighPrice"] = float(round(data["High"][stockCode][1], 2))
        j["stockVolume"] = float(round(data["Volume"][stockCode][1], 2))
        j["stockOpenPrice"] = float(round(data["Open"][stockCode][1], 2))
        j["stockClosingPrice"] = float(round(data["Close"][stockCode][0], 2))
        j["stockChange"] = float(
            round(data["Close"][stockCode][1] - data["Close"][stockCode][0], 2)
        )
        j["stockPerChange"] = float(
            round(
                (data["Close"][stockCode][1] - data["Close"][stockCode][0])
                / data["Close"][stockCode][0]
                * 100,
                2,
            )
        )
        j["DayNewsConut"] = 0
        j["TimeNewsCount"] = 0
        j["TimePerPositiveNewsCount"] = 0
        j["TimePerNegativeNewsCount"] = 0


def firebase_transaction():
    db = firestore.client()

    def AddFirebase(item):
        db.collection("stock").document(item["stockName"]).set(item)

    pool = ThreadPool(10)

    for _ in tqdm(pool.imap_unordered(AddFirebase, company), total=len(company)):
        pass

    pool.close()
    pool.join()


def run(reset):
    # 계산된 횟수만 실행
    print("run")
    stock_information_getTime()
    while reset:
        get_companylist()
        stock_pretreatment()
        firebase_transaction()
        print("남은횟수: ", reset)
        start = time.time()
        tuple_list = []
        tuple_list.append(("stock", "title", "url", "date", "pov_or_neg"))
        id_key = reset % 2
        st = time.time()
        #### Pool 프로세스 수는 변경 가능
        pool = ThreadPool(10)
        for _ in tqdm(
            pool.starmap(
                api_search,
                [(tuple_list, stock["stockName"], id_key) for stock in company],
            ),
            total=len(company),
        ):
            pass
        pool.close()
        pool.join()
        print("quering end, it takes to ", int(time.time() - st), "s")
        # 쿼링 포함 15분 제한
        print("sleep ")
        end = time.time()
        rest_time = 900 - (end - start) if 900 - (end - start) > 0 else 0
        time.sleep(rest_time)

        reset -= 1


# 8시 20분에 주식가져옴
schedule.every().day.at("08:20").do(get_companylist)
# 8시 30분에 코드 실행
schedule.every().day.at("08:30").do(run, 31)

if __name__ == "__main__":
    print("start")
    # 주식 종목을 global로 설정
    get_companylist()
    now = datetime.datetime.now()
    time_now = datetime.timedelta(hours=now.hour, minutes=now.minute)
    time_start = datetime.timedelta(hours=0, minutes=00)
    time_end = datetime.timedelta(hours=24, minutes=00)
    # 시간 계산해서 장 중일 때만 작동하도록..
    if (time_now > time_start) and (time_end > time_now):
        time_diff_s = (time_end - time_now).total_seconds()
        time_diff_m = time_diff_s / 60
        run_time = int(time_diff_m / 15)

        run(run_time)
    while True:
        schedule.run_pending()
        time.sleep(1)
