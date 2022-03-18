import codecs
import requests
from bs4 import BeautifulSoup
import re
import pandas as pd

positive = []
negative = []
posneg = []

pos = codecs.open("/Users/seungjun/Desktop/git/capstone-2022-07/model/positive_words_self.txt", 'rb', encoding='UTF-8')
while True :
    line = pos.readline()
    line = line.replace('\n','')
    positive.append(line)
    posneg.append(line)
    
    if not line : break
pos.close()

neg = codecs.open("/Users/seungjun/Desktop/git/capstone-2022-07/model/negative_words_self.txt", 'rb', encoding='UTF-8')
while True :
    line = neg.readline()
    line = line.replace('\n','')
    negative.append(line)
    posneg.append(line)
    
    if not line : break
neg.close()


labels =[]
titles = []


j = 0

for i in range(400):
    num = i *10 + 1
    
    url = "https://search.naver.com/search.naver?&where=news&query=%EB%B2%84%EA%B1%B0%ED%82%B9&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&nso=so:r,p:all,a:all&mynews=0&cluster_rank=23&start=" + str(num)
    
    req = requests.get(url)
    
    soup = BeautifulSoup(req.text, 'lxml')
    
    titles = soup.select("a._sp_each_title")
    
    for title in titles :
        
        title_data = title.text
        clean_title = re.sub('[-=+,#/\?:^$.@*\"~$%!\'|\(\)\[\]\<\>','',title)
        negative_flag = False
        label = 0
        for i in range(len(negative)):
            if negative[i] in clean_title:
                label = -1
                negative_flag = True
                print("negative 비교 단어 : ", negative[i], "clean_title : ", clean_title)
                break
        if negative_flag == False:
            for i in range(len(positive)):
                if positive[i] in clean_title:
                    label = 1
                    print("positive 비교단어 : ", positive[i], "clean_title : ", clean_title)
                    break
                titles.append(clean_title)
                labels.append(label)
                
    my_title_df = pd.DataFrame({"title":titles, "label":labels})
    