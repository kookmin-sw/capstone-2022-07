from bs4 import BeautifulSoup
import requests
import re
import time
import itertools
import csv
import datetime

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


url_stock = "http://api.seibro.or.kr/openapi/service/StockSvc/getKDRSecnInfo"  # 공공데이터포털 api 주소(Without param)
api_service_key_stock = [
    "RXhGWArdgsytKaKf0g%2FWxNuo27wXxg4iChLUs9ePc39VvneddFbQ9v9ZXCDWJkdFbhqCvbw9kdMGy%2F%2Bv3it50A%3D%3D",
    "bqvyeN8k%2B8%2BfRLf7p4CNQsUIEL%2BRb4b2YR08MD10RDv3BxHugq6bR1wFEAo8hTau3XgiLcA7bEBoclnMdyBfNQ%3D%3D",
    "zUgkw3obrruAXAW6kZrJnIpK8UUBIrwXrfroSgoDS7NUlSB%2BDz94OTIkkWeP0V%2BzOz81JVtW84bqh1y0HpzcUg%3D%3D",
    "w9Ra19Zqn3%2BLgg2zHoRiZa8zZPdSCXSgFgrgFGUkaYqqQRD6BVKMsUgiRyJqeEuG1pQ86vSioq03IRarAve7sg%3D%3D",
]  # service api key

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

def date_clean(inputdate):
    print()

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

# 네이버 api 함수
def api_search(tuple_list, stock):
    url = 'https://openapi.naver.com/v1/search/news.json' 
    header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
    param = {'query':stock, 'display':10, 'start':1, 'sort':'date'} 
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
        """
        긍부정 판별 코드 추가 필요
        긍부정 판별 변수   
        pov_or neg로 저장
        """

        for dict in temp['items']:
            title  = text_clean(dict['title'])
            date = formatting_date(dict['pubDate'])

            tuple_list.append((stock ,title ,dict['originallink'] ,date ,pov_or_neg))

    else:
        print("Error Code:" + str(res.status_code)+" Stock name is "+ str(stock))

@logging_time
def run():
    temp = list()
    temp.append(getStockCode(11, "StockSvc"))
    temp.append(getStockCode(12, "StockSvc"))
    company = list(itertools.chain.from_iterable(temp))

    tuple_list=[]
    for query in company:

        api_search(tuple_list, query) 

    #tuple to csv 저장
    with open('news.csv', 'w') as f:
        writer = csv.writer(f , lineterminator='\n')
        for tup in tuple_list:
            writer.writerow(tup)


if __name__ == "__main__":
    run()