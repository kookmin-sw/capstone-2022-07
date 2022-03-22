# -*- coding: utf-8 -*-
from audioop import mul
import multiprocessing
from bs4 import BeautifulSoup
from datetime import datetime, timedelta
import requests
import pandas as pd
import re
from multiprocessing import Manager, Pool, freeze_support  # Pool import하기
import time
import itertools
import pickle
import csv
import urllib.request

url_stock = "http://api.seibro.or.kr/openapi/service/StockSvc/getKDRSecnInfo"  # 공공데이터포털 api 주소(Without param)
api_service_key_stock = [
    "RXhGWArdgsytKaKf0g%2FWxNuo27wXxg4iChLUs9ePc39VvneddFbQ9v9ZXCDWJkdFbhqCvbw9kdMGy%2F%2Bv3it50A%3D%3D",
    "bqvyeN8k%2B8%2BfRLf7p4CNQsUIEL%2BRb4b2YR08MD10RDv3BxHugq6bR1wFEAo8hTau3XgiLcA7bEBoclnMdyBfNQ%3D%3D",
    "zUgkw3obrruAXAW6kZrJnIpK8UUBIrwXrfroSgoDS7NUlSB%2BDz94OTIkkWeP0V%2BzOz81JVtW84bqh1y0HpzcUg%3D%3D",
    "w9Ra19Zqn3%2BLgg2zHoRiZa8zZPdSCXSgFgrgFGUkaYqqQRD6BVKMsUgiRyJqeEuG1pQ86vSioq03IRarAve7sg%3D%3D",
]  # service api key

# 각 크롤링 결과 저장하기 위한 리스트 선언
title_text = []
link_text = []
source_text = []
date_text = []
contents_text = []
result = {}

# 엑셀로 저장하기 위한 변수
# RESULT_PATH = "/Users/bumseok/workspace/2022-Capstone"

# 결과 저장할 경로
now = datetime.now()  # 파일이름 현 시간으로 저장하기

# 시간 측정 함수
def logging_time(original_fn):
    def wrapper_fn(*args, **kwargs):
        start_time = time.time()
        result = original_fn(*args, **kwargs)
        end_time = time.time()
        print(
            "WorkingTime[{}]: {} sec".format(
                original_fn.__name__, end_time - start_time
            )
        )
        return result

    return wrapper_fn


# 종목 이름 가져오는 코드
@logging_time
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


# 날짜 정제화 함수
def date_cleansing(test):
    try:
        # 지난 뉴스
        # 머니투데이  10면1단  2018.11.05.  네이버뉴스   보내기
        pattern = "\d+.(\d+).(\d+)."  # 정규표현식

        r = re.compile(pattern)
        match = r.search(test).group(0)  # 2018.11.05.
        date_text.append(match)

    except AttributeError:
        # 최근 뉴스
        # 이데일리  1시간 전  네이버뉴스   보내기
        pattern = "\w* (\d\w*)"  # 정규표현식

        match = r.search(test).group(1)
        # print(match)
        date_text.append(match)


# 내용 정제화 함수
def contents_cleansing(contents):
    first_cleansing_contents = re.sub(
        "<dl>.*?</a> </div> </dd> <dd>", "", str(contents)
    ).strip()  # 앞에 필요없는 부분 제거
    second_cleansing_contents = re.sub(
        '<ul class="relation_lst">.*?</dd>', "", first_cleansing_contents
    ).strip()  # 뒤에 필요없는 부분 제거 (새끼 기사)
    third_cleansing_contents = re.sub("<.+?>", "", second_cleansing_contents).strip()
    contents_text.append(third_cleansing_contents)


# def crawler(title_list, url_list, temp_list, result_dict, query):
def crawler(tuple_list, query):
    # s_from = s_date.replace(".","")
    # e_to = e_date.replace(".","")
    s_date = now.strftime("%Y.%m.%d.%H.%M")
    yesterday = now - timedelta(days=1)
    e_date = yesterday.strftime("%Y.%m.%d.%H.%M")
    page = 1
    maxpage = 1
    

    # 11= 2페이지 21=3페이지 31=4페이지  ...81=9페이지 , 91=10페이지, 101=11페이지
    maxpage_t = (int(maxpage) - 1) * 10 + 1

    sort = 1

    while page <= maxpage_t:
        url = (
            "https://search.naver.com/search.naver?where=news&query="
            + query
            + "&sort="
            + str(sort)
            + "&pd=4&ds="
            + s_date
            + "&de="
            + e_date
            + "&nso=so%3Ar%2Cp%3A&start="
            + str(page)
        )
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36"
        }
        response = requests.get(url, headers=headers)
        html = response.text

        # 뷰티풀소프의 인자값 지정
        soup = BeautifulSoup(html, "html.parser")

        atags = soup.select(".news_tit")
        news_name =""
        news_date =""
        news_url = ""
        pov_or_neg = 0 #긍부정 라벨링 값

        # <a>태그에서 제목과 링크주소 추출
        # 기사 제목, 기사url 저장 
        for atag in atags:
            # title_text.append(atag.text)  # 제목
            # link_text.append(atag["href"])  # 링크주소
            # title_list.append(atag.text)
            # url_list.append(atag["href"])
            news_name = atag.text
            news_url = atag["href"]
            
            # TODO
            """
            긍부정 판별 코드 추가 필요

            긍부정 판별 변수   
            pov_or neg로 저장
            """

        # 날짜 추출
        date_lists = soup.select(".info_group > span.info")
        for date_list in date_lists:
            # 1면 3단 같은 위치 제거
            if date_list.text.find("면") == -1:
                # date_text.append(date_list.text)
                news_date=date_list.text

        tuple_list.append((query, news_name, news_url, news_date, pov_or_neg))

        # # 본문요약본
        # contents_lists = soup.select(".news_dsc")
        # for contents_list in contents_lists:
        #     contents_cleansing(contents_list)  # 본문요약 정제화

        page += 10


# Naver client key
client_id= "4NnYXQRzNVwTEO2_rwpd"
client_secret = "mZP8JBDOBK"
def api_search(tuple_list, stock):
    url = 'https://openapi.naver.com/v1/search/news.json' 
    header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
    param = {'query':stock, 'display':5, 'start':1, 'sort':'date'} 
    # query     : 검색할 단어
    # display   : 검색 출력 건수 (기본 10 / 최대 100)
    # start     : 검색 시작 위치 (기본 1  / 최대 1000)
    # sort      : 정렬순서      (기본 sim : 유사도 / date : 날짜)
    res = requests.get(url, params=param, headers=header)

    pov_or_neg = 0 #긍부정 라벨링 값

    if res.status_code == 200:
        temp = res.json()

        # print(type(temp))
        # for index, item in enumerate(temp['items']):
        #     print(index+1, item['title'], item['link'], item['description'],item['pubDate'])

        # TODO
        """
        긍부정 판별 코드 추가 필요

        긍부정 판별 변수   
        pov_or neg로 저장
        """

        for dict in temp['items']:
            tuple_list.append((stock,dict['title'],dict['originallink'],dict['description'],dict['pubDate'],pov_or_neg))

        # with open('test_api.csv','w') as f:
        #     w = csv.writer(f)
        #     for i in temp['items']:
        #         i['name']=stock
        #         w.writerow(i.values())
        # print(temp['items'])
    else:
        print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))


def run():
    temp = list()
    temp.append(getStockCode(11, "StockSvc"))
    temp.append(getStockCode(12, "StockSvc"))
    company = list(itertools.chain.from_iterable(temp))

    start = time.time()

    # pool = Pool(4)
    # m = Manager()

    # title_list = m.list()
    # url_list = m.list()
    # result_dict = m.dict()

    # tuple_list = m.list()

    # process = multiprocessing.cpu_count() * 2
    # # print(company)
    # with Pool(processes=process) as pool:
    #     pool.starmap(
    #         # crawler, [(tuple_list, query) for query in company[:40]] ###### 크롤링 함수 사용시
    #         api_search, [(tuple_list, query) for query in company] ###### api 함수 사용시
    #     )
    #     pool.close()
    #     pool.join()
    tuple_list=[]
    for query in company:
        api_search(tuple_list, query) ###### api 함수 사용시

    end = time.time()
    """ pickle 내보내기 
    dict = {
        "title": title_list,
        "urls": url_list,
    }

    with open('user.pkl','wb') as f:
        pickle.dump(dict, f)
    
    with open('user.pkl', 'rb') as f:
        data = pickle.load(f)
    print(data["title"])
    print(dict["title"])

    """

    print("끝 : 걸린시간 : ")
    print(f"{end - start:.5f} sec")

    #tuple to csv 저장
    with open('news.csv', 'w') as f:
        writer = csv.writer(f , lineterminator='\n')
        for tup in tuple_list:
            writer.writerow(tup)


if __name__ == "__main__":
    run()
