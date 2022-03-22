import codecs
import csv 

positive = []
negative = []
posneg = []

pos = codecs.open("/Users/seungjun/Desktop/git/capstone-2022-07/model/positive_words.txt", 'rb', encoding='UTF-8')
while True :
    line = pos.readline()
    line = line.replace('\n','')
    positive.append(line)
    posneg.append(line)
    
    if not line : break
pos.close()

neg = codecs.open("/Users/seungjun/Desktop/git/capstone-2022-07/model/negative_words.txt", 'rb', encoding='UTF-8')
while True :
    line = neg.readline()
    line = line.replace('\n','')
    negative.append(line)
    posneg.append(line)
    
    if not line : break
neg.close()


print(positive)
temp =[]
with open('./train.csv', 'w') as f:
    writer = csv.reader(f , lineterminator='\n')
    for tup in writer:
        print(type(tup))