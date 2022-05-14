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
import datetime
from multiprocessing.dummy import Pool as ThreadPool
import schedule
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer
from dotenv import load_dotenv
import os
from dateutil import parser

# firebase 관련
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db
from firebase_admin import messaging
from pyfcm import FCMNotification

# 멀티프로세싱
from multiprocessing import Manager, Pool, freeze_support

import tensorflow as tf

physical_devices = tf.config.list_physical_devices("GPU")
tf.config.experimental.set_memory_growth(physical_devices[0], enable=True)
# tf.config.experimental.set_visible_devices(physical_devices[0], device_type="GPU")

# warning 문자 무시
import warnings

warnings.filterwarnings("ignore")

import keras

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
    "승리",
    "안타",
    "홈런",
    "패배",
    "야구",
    "축구",
]
url_del_list = [
    "econonews",
    "xportsnews",
    "kgnews",
    "dailycc",
    "ccdailynews",
    "joongdo",
    "ujeil.com",
    "namdotoday.kr",
    "kado.net",
    "cdn.jemin.com",
    "jjn.co.kr",
    "newsis",
    "kyeonggi",
    "gjdream",
    "jeonmae",
    "japan",
    "btnnews",
    "jejumaeil",
    "busan",
    "mksports",
    "jeollailbo",
    "mydaily.co",
    "stoo.com",
    "mk.co.kr/star",
    "etoday",
    "jnilbo",
    "lecturernews",
    "kwnews",
    "idomin",
    "knnews",
    "gnnews",
    "kyongbuk.co.kr",
    "gsinews.com",
    "ksilbo.co.kr",
    "gailbo",
    "idaegu.co.kr" "kyeongin",
    "gwangnam",
    "kwangju",
    "kjdaily",
    "namdonews",
    "daejonilbo",
    "imaeil",
    "mdilbo",
    "busan",
    "andongdaily",
    "jndn",
    "jnilbo",
    "jjan",
    "jejunews.",
    "ihalla",
    "sport",
]
link_del_list = [
    "sports",
    "sport",
]
desc_del_list = [
    "제보",
    "극장",
]

# 형태소분석
# JVM_PATH = "/Library/Java/JavaVirtualMachines/zulu-15.jdk/Contents/Home/bin/java"
# okt = Okt(jvmpath=JVM_PATH)
okt = Okt()
tokenizer = Tokenizer(num_words=35000)
max_len = 20

train_data = pd.read_csv("./train.csv", names=["title", "label"])

X_train = []
for sentence in tqdm(train_data["title"]):
    temp_X = []
    temp_X = okt.morphs(str(sentence), stem=True)  # 토큰화
    temp_X = [word for word in temp_X if not word in stopwords]  # 안쓰는 말 제거
    X_train.append(temp_X)
max_words = 35000
tokenizer = Tokenizer(num_words=max_words)
tokenizer.fit_on_texts(X_train)
X_train = tokenizer.texts_to_sequences(X_train)
# 정규화
y_train = []
for i in tqdm(range(len(train_data["label"]))):
    if train_data["label"].iloc[i] == 1:
        y_train.append([0, 0, 1])
    elif train_data["label"].iloc[i] == 0:
        y_train.append([0, 1, 0])
    elif train_data["label"].iloc[i] == -1:
        y_train.append([1, 0, 0])
y_train = np.array(y_train)

model = keras.models.load_model("train.h5")

# 쿼링 보낼 database
if not firebase_admin._apps:
    cred = credentials.Certificate("./firebase_key.json")
    default_app = firebase_admin.initialize_app(cred)
# firebase_admin.initialize_app(cred, {
#  'projectId': 'capstone-2022-07-dac76',
# })

db = firestore.client()


def send_messaging_increase(stockName, stockCode, stockPerChange):
    # Define a condition which will send to devices which are subscribed
    # to either the Google stock or the tech industry topics.
    condition = f"'interest' in topics && '{stockCode}' in topics"

    # See documentation on defining a message payload.
    message = messaging.Message(
        notification=messaging.Notification(
            title=f"종목 급등 알림",
            body=f"{stockName} 종목의 주가가 {stockPerChange}% 상승했습니다!",
        ),
        data={
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "screen": "Stockscreen",
            "stockName": stockName,
            "stockCode": stockCode,
        },
        condition=condition,
    )

    # Send a message to devices subscribed to the combination of topics
    # specified by the provided condition.
    response = messaging.send(message)
    # Response is a message ID string.
    print("Successfully sent message:", response)


def send_messaging_decrease(stockName, stockCode, stockPerChange):
    # Define a condition which will send to devices which are subscribed
    # to either the Google stock or the tech industry topics.
    condition = f"'interest' in topics && '{stockCode}' in topics"

    # See documentation on defining a message payload.
    message = messaging.Message(
        notification=messaging.Notification(
            title=f"종목 급락 알림",
            body=f"{stockName} 종목의 주가가 {stockPerChange}% 하락했습니다.",
        ),
        data={
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "screen": "Stockscreen",
            "stockName": stockName,
            "stockCode": stockCode,
        },
        condition=condition,
    )

    # Send a message to devices subscribed to the combination of topics
    # specified by the provided condition.
    response = messaging.send(message)
    # Response is a message ID string.
    print("Successfully sent message:", response)


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
    stock_code = reset % 4
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
        .replace("/xa0", "")
    )
    inputString = " ".join(inputString.split())

    return inputString


def text_clean_origin(inputString):
    inputString = (
        inputString.replace("<b>", "").replace("</b>", "").replace("/xa0", "")
    )  # html 태그 제거  ## <b> <b/>
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
    date = parser.parse(date)  # str to datetime
    date = date.strftime("%Y-%m-%d %H:%M:%S")  # changing datetime format

    return date


# 날짜 -> timestamp = 뉴스의 중복 제거를 위함
def time_to_stamp(date):
    date = date.replace("0900", "0000")
    date = parser.parse(date)  # str to datetime

    return date


# Naver client key
Naver_client_id = [
    "4NnYXQRzNVwTEO2_rwpd",
    "8Sbpzhlz4LPc0MPsiaOO",
    "W0rf6z9LoaD9FTwEEaxE",
    "UbpsmtlCKuB3eb0dxGgw",
]
Naver_client_secret = ["mZP8JBDOBK", "HPqxX8HZfG", "ugLCC3LW85", "CRmEzrXlb7"]

temp_dt = parser.parse("Thu, 01 Mar 2022 06:02:00 +0900")
print(temp_dt)

# 네이버 api 함수
def api_search(tuple_list, stock, id_key):
    url = "https://openapi.naver.com/v1/search/news.json"
    header = {
        "X-Naver-Client-Id": Naver_client_id[id_key],
        "X-Naver-Client-Secret": Naver_client_secret[id_key],
    }
    param = {"query": stock, "display": 100, "start": 1, "sort": "date"}
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

        global stock_news_list
        stock_news_list = []

        for dict in temp["items"]:
            news_timestamp = time_to_stamp(dict["pubDate"])

            if endPoint > news_timestamp:
                break
            # if dict['title'].find(stock) == -1:
            #     continue
            origin_title = text_clean_origin(dict["title"])
            title = text_clean(dict["title"])
            # try:
            #     if origin_title[origin_title.find(str(stock))+len(str(stock))] ==' ' or origin_title[origin_title.find(str(stock))+len(str(stock))] ==',' :
            #             pass
            #     else :
            #         continue
            # except:
            #     continue
            if any(keyword in dict["link"] for keyword in link_del_list):
                continue
            if any(keyword in dict["description"] for keyword in desc_del_list):
                continue
            if any(keyword in dict["originallink"] for keyword in url_del_list):
                continue
            # 학습데이터를 통해서 라벨링
            X_test = []
            temp_X = okt.morphs(str(title), stem=True)  # 토큰화
            temp_X = [word for word in temp_X if not word in stopwords]  # 안쓰는 말 제거
            X_test.append(temp_X)
            X_test = tokenizer.texts_to_sequences(X_test)
            X_test = pad_sequences(X_test, maxlen=max_len)
            predict = model.predict(X_test)
            # 호악재 예측값 저장
            pov_or_neg = np.argmax(predict, axis=1)[0]
            predict_labels = np.argmax(predict, axis=1)
            prediction = round(predict[0][predict_labels[0]], 2)
            date = formatting_date(dict["pubDate"])

            stock_news_list.append(
                {
                    "date": date,
                    "title": str(origin_title),
                    "label": str(pov_or_neg),
                    "url": dict[str("originallink")],
                    "timestamp": news_timestamp,
                    "prediction": float(prediction),
                    "context": text_clean_origin(dict["description"]),
                }
            )

            tuple_list.append((stock, title, dict["originallink"], date, pov_or_neg))

            # print(stock ,title ,dict['originallink'] ,date ,pov_or_neg)
    else:
        print("Error Code:" + str(res.status_code) + " Stock name is " + str(stock))

    def AddFirebaseToNews(item):
        db.collection("stock").document(stock).collection("news").document().set(item)

    pool = ThreadPool(10)

    for _ in pool.imap_unordered(AddFirebaseToNews, stock_news_list):
        pass

    pool.close()
    pool.join()

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

    try:
        news_temp = db.collection("stock").document(stock)
        news_temp.update(
            {
                "DayNewsCount": DayNewsCount,
                "TimeNewsCount": TimeNewsCount,
                "TimePerPositiveNewsCount": TimePerPositiveNewsCount,
                "TimePerNegativeNewsCount": TimePerNegativeNewsCount,
            }
        )
    except:
        pass


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
        flag = True
    else:
        previous = XKRX.previous_minute(
            corr_current.strftime("%Y-%m-%d %H:%M")
        ).strftime("%Y-%m-%d")
        time_previous = XKRX.previous_minute(
            corr_current.strftime("%Y-%m-%d %H:%M")
        ) + datetime.timedelta(hours=9)
        pre_previous = XKRX.previous_session(previous).strftime("%Y-%m-%d")
        time_previous = str(time_previous.strftime("%Y-%m-%d %H:%M"))
        flag = False

    print(pre_previous)
    data = yf.download(["^KS11", "^KQ11"], start=pre_previous)
    print(data["Close"]["^KS11"][-1])
    try:
        float(data["Close"]["^KS11"][1])
    except:
        pre_previous = XKRX.previous_session(pre_previous).strftime("%Y-%m-%d")

    return flag


def stock_pretreatment():
    data = yf.download(code_list, start=pre_previous)
    # item_list에 각 필드들 쿼링
    for j in tqdm(company):
        stockCode = j["stockCode"]
        if j["stockCode"] != "^KS11" and j["stockCode"] != "^KQ11":
            stockCode += ".KS"

        j["stockPrice"] = float(data["Close"][stockCode][-1])
        j["stockLowPrice"] = float(data["Low"][stockCode][-1])
        j["stockHighPrice"] = float(data["High"][stockCode][-1])
        j["stockVolume"] = float(data["Volume"][stockCode][-1])
        j["stockOpenPrice"] = float(data["Open"][stockCode][-1])
        j["stockClosingPrice"] = float(data["Close"][stockCode][-2])
        j["stockChange"] = float(
            data["Close"][stockCode][-1] - data["Close"][stockCode][-2]
        )
        j["stockPerChange"] = float(
            (data["Close"][stockCode][-1] - data["Close"][stockCode][-2])
            / data["Close"][stockCode][-2]
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
        j["stockPrice"] = float(round(data["Close"][stockCode][-1], 2))
        j["stockLowPrice"] = float(round(data["Low"][stockCode][-1], 2))
        j["stockHighPrice"] = float(round(data["High"][stockCode][-1], 2))
        j["stockVolume"] = float(round(data["Volume"][stockCode][-1], 2))
        j["stockOpenPrice"] = float(round(data["Open"][stockCode][-1], 2))
        j["stockClosingPrice"] = float(round(data["Close"][stockCode][-2], 2))
        j["stockChange"] = float(
            round(data["Close"][stockCode][-1] - data["Close"][stockCode][-2], 2)
        )
        j["stockPerChange"] = float(
            round(
                (data["Close"][stockCode][-1] - data["Close"][stockCode][-2])
                / data["Close"][stockCode][-2]
                * 100,
                2,
            )
        )
        j["DayNewsCount"] = 0
        j["TimeNewsCount"] = 0
        j["TimePerPositiveNewsCount"] = 0
        j["TimePerNegativeNewsCount"] = 0


def firebase_transaction_messaging():
    def AddFirebase(item):
        db.collection("stock").document(item["stockName"]).set(item)
        if item["stockPerChange"] >= 5:
            send_messaging_increase(
                item["stockName"], item["stockCode"], item["stockPerChange"]
            )
        elif item["stockPerChange"] <= -5:
            send_messaging_decrease(
                item["stockName"], item["stockCode"], item["stockPerChange"]
            )

    pool = ThreadPool(10)

    for _ in tqdm(pool.imap_unordered(AddFirebase, company), total=len(company)):
        pass

    pool.close()
    pool.join()


def firebase_transaction():
    def AddFirebase(item):
        db.collection("stock").document(item["stockName"]).set(item)

    pool = ThreadPool(10)

    for _ in tqdm(pool.imap_unordered(AddFirebase, company), total=len(company)):
        pass

    pool.close()
    pool.join()


def run():
    global reset
    print(f"run, {reset}")
    if stock_information_getTime():
        stock_pretreatment()
        firebase_transaction()
    tuple_list = []
    tuple_list.append(("stock", "title", "url", "date", "pov_or_neg"))
    id_key = reset % 4
    st = time.time()

    #### Pool 프로세스 수는 변경 가능
    pool = ThreadPool(4)
    for _ in tqdm(
        pool.starmap(
            api_search,
            [(tuple_list, stock["stockName"], id_key) for stock in company],
        ),
        total=len([(tuple_list, stock["stockName"], id_key) for stock in company]),
    ):
        pass

    pool.close()
    pool.join()
    print("quering end, it takes to ", int(time.time() - st), "s")

    reset += 1


reset = 0

# 8시 20분에 주식가져옴
schedule.every().day.at("08:20").do(get_companylist)
schedule.every().day.at("13:30").do(firebase_transaction_messaging)
schedule.every(15).minutes.do(run)


if __name__ == "__main__":
    print("start")
    get_companylist()
    stock_information_getTime()
    stock_pretreatment()
    firebase_transaction()
    run()
    while True:
        schedule.run_pending()
        time.sleep(1)
