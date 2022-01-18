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


url_stock = "http://api.seibro.or.kr/openapi/service/StockSvc/getKDRSecnInfo"  # 공공데이터포털 api 주소(Without param)
api_service_key_stock = "RXhGWArdgsytKaKf0g%2FWxNuo27wXxg4iChLUs9ePc39VvneddFbQ9v9ZXCDWJkdFbhqCvbw9kdMGy%2F%2Bv3it50A%3D%3D"  # service api key
api_decode_key_stock = requests.utils.unquote(
    api_service_key_stock, encoding="utf-8"
)  # api decode code

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
    api_key_decode = requests.utils.unquote(api_decode_key_stock, encoding="utf-8")

    params = {
        "serviceKey": api_key_decode,
        "pageNo": 1,
        "numOfRows": 100000,
        "martTpcd": market,
    }

    response = requests.get(url, params=params)
    # print(response.text)
    xml = BeautifulSoup(response.text, "lxml")
    items = xml.find("items")
    item_list = []
    for item in items:
        item_list.append(item.find("korsecnnm").text.strip())

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

        r = re.compile(pattern)
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


def crawler(title_list, url_list, result_dict, query):
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

        response = requests.get(url)
        html = response.text

        # 뷰티풀소프의 인자값 지정
        soup = BeautifulSoup(html, "html.parser")

        # <a>태그에서 제목과 링크주소 추출
        atags = soup.select(".news_tit")
        for atag in atags:
            title_text.append(atag.text)  # 제목
            link_text.append(atag["href"])  # 링크주소
            title_list.append(atag.text)
            url_list.append(atag["href"])

        # 날짜 추출
        date_lists = soup.select(".info_group > span.info")
        for date_list in date_lists:
            # 1면 3단 같은 위치 제거
            if date_list.text.find("면") == -1:
                date_text.append(date_list.text)

        # 본문요약본
        contents_lists = soup.select(".news_dsc")
        for contents_list in contents_lists:
            contents_cleansing(contents_list)  # 본문요약 정제화

        page += 10


def run():

    temp = list()
    temp.append(getStockCode(11, "StockSvc"))
    temp.append(getStockCode(12, "StockSvc"))
    company = list(itertools.chain.from_iterable(temp))

    start = time.time()

    pool = Pool(4)
    m = Manager()
    title_list = m.list()
    url_list = m.list()
    result_dict = m.dict()

    process = multiprocessing.cpu_count() * 2
    # print(company)
    with Pool(processes=process) as pool:
        pool.starmap(
            crawler, [(title_list, url_list, result_dict, query) for query in company]
        )
        pool.close()
        pool.join()

    end = time.time()
    dict = {
        "title": title_list,
        "urls": url_list,
    }
    print(dict["title"])
    print(len(title_list))
    print(len(url_list))
    print(f"{end - start:.5f} sec")


if __name__ == "__main__":
    run()
