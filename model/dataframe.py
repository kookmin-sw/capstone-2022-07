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


label = [0] * 4000
my_title_dic = {"title":[], "label":label}
j = 0

for i in range(4):
    num = i *10 + 1
    
    url = "https://search.naver.com/search.naver?&where=news&query=%EB%B2%84%EA%B1%B0%ED%82%B9&sm=tab_pge&sort=0&photo=0&field=0&reporter_article=&pd=0&ds=&de=&docid=&nso=so:r,p:all,a:all&mynews=0&cluster_rank=23&start=" + str(num)
    
    req = requests.get(url)
    
    soup = BeautifulSoup(req.text, 'lxml')
    
    titles = soup.select("a._sp_each_title")
    
    for title in titles :
        title_data = title.text
        title_data = re.sub('[-=+,#/\?:^$.@*\"~$%!\'|\(\)\[\]\<\>','',title_data)
        my_title_dic['title'].append(title_data)
        
        for i in range(len(posneg)):
            posflag = False
            negflag = False
            if i < (len(positive)-1):
                #print(title_data.find(posneg[i]))
                if title_data.find(posneg[i]) != -1:
                    posflag = True
                    print(i, "positive?", "테스트 : ", title_data.find(posneg[i]), "비교단어 : ", posneg[i], "인덱스 : ", i, title_data)
                    break
            if i > (len(positive)-2):
                if title_data.find(posneg[i] != -1):
                    negflag = True
                    print(i, "negative?", "테스트 : ", title_data.find(posneg[i]), "비교단어 : ", posneg[i], "인덱스 : ", i, title_data)
                    break
                    
        if posflag == True:
            label[j] = 1
            #print("positive", j)
        elif negflag == True :
            label[j] = -1
            #print("negative", j)
        elif negflag == False and posflag == False:
            label[j] = 0
            #print("objective", j)
        j = j +1
my_title_dic['label'] = label
my_title_df = pd.DataFrame(my_title_dic)

#출력
#def dftoCsv(my_title_df, num):
    #my_title_df.to_csv(('./title_datas' + str(num)+ '.csv'), sep = ',', na_rep='NaN', encoding='utf-8')
    
#result = dftoCsv    