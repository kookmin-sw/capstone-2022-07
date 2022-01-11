import requests
from bs4 import BeautifulSoup
import pandas as pd
import time
import urllib.request


url = "http://api.seibro.or.kr/openapi/service/StockSvc/getKDRSecnInfo"
api_service_key_stock = "RXhGWArdgsytKaKf0g%2FWxNuo27wXxg4iChLUs9ePc39VvneddFbQ9v9ZXCDWJkdFbhqCvbw9kdMGy%2F%2Bv3it50A%3D%3D"
api_decode_key_stock = requests.utils.unquote(api_service_key_stock, encoding="utf-8")
client_id_search = "4NnYXQRzNVwTEO2_rwpd"
client_secret_search = "mZP8JBDOBK"


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


@logging_time
def getStockCode(market, url_param) -> pd.DataFrame:
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
    xml = BeautifulSoup(response.text, "lxml")
    items = xml.find("items")
    item_list = []
    for item in items:
        item_list.append(item.find("korsecnnm").text.strip())
    return item_list


cospi = getStockCode(11, "StockSvc")
print(cospi)
# cosdak = getStockCode(12, "StockSvc")


def search(stock):
    encText = urllib.parse.quote(stock)  # 검색할 키워드
    url = (
        "https://openapi.naver.com/v1/search/news?query=" + encText
    )  # json 결과가 필요할 때 사용
    # url = "https://openapi.naver.com/v1/search/news.xml?query=" + encText # xml 결과가 필요할 때 사용

    request = urllib.request.Request(url)
    request.add_header("X-Naver-Client-Id", client_id_search)
    request.add_header("X-Naver-Client-Secret", client_secret_search)
    response = urllib.request.urlopen(request)
    rescode = response.getcode()
    if rescode == 200:
        response_body = response.read()
        return response_body.decode("utf-8")
    else:
        print("Error Code:" + rescode)


start = time.time()
for i in cospi:
    if i == "삼성전자":
        print(search(i))
    search(i)
end = time.time()
print(f"{end - start:.5f} sec")
