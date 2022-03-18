# 네이버 검색 API예제는 블로그를 비롯 전문자료까지 호출방법이 동일하므로 blog검색만 대표로 예제를 올렸습니다.
# 네이버 검색 Open API 예제 - 블로그 검색
import os
import sys
import csv
import urllib.request
import requests
from collections import OrderedDict

client_id = "4NnYXQRzNVwTEO2_rwpd"
client_secret= "mZP8JBDOBK"

def search(stock):

    encText = urllib.parse.quote(stock)
    url = "https://openapi.naver.com/v1/search/news.json?query=" + encText # json 결과
    # url = "https://openapi.naver.com/v1/search/blog.xml?query=" + encText # xml 결과
    request = urllib.request.Request(url)
    request.add_header("X-Naver-Client-Id",client_id)
    request.add_header("X-Naver-Client-Secret",client_secret)
    response = urllib.request.urlopen(request)
    rescode = response.getcode()
    if(rescode==200):
        response_body = response.read()
        print(response_body.decode('utf-8'))
    else:
        print("Error Code:" + rescode)


def api(list, stock):
    url = 'https://openapi.naver.com/v1/search/news.json' 
    header = {'X-Naver-Client-Id':client_id, 'X-Naver-Client-Secret':client_secret} 
    param = {'query':stock, 'display':5, 'start':1, 'sort':'date'} 
    res = requests.get(url, params=param, headers=header)

    if res.status_code == 200:
        temp = res.json()

        # print(type(temp))

        # for index, item in enumerate(temp['items']):
        #     print(index+1, item['title'], item['link'], item['description'],item['pubDate'])

        list.append(())

        with open('test_api.csv','w') as f:
            w = csv.writer(f)
            for i in temp['items']:
                i['name']=stock
                w.writerow(i.values())
        # print(temp['items'])
    else:
        print("Error Code:" + res.status_code+" Stock name is "+stock)

if __name__ == "__main__":
    temp_list=[]
    api(temp_list, "카카오")