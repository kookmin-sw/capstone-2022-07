import codecs

positive = []
negative = []
posneg = []

pos = codecs.open("/Users/lwh/WORKSPACE/capstone-2022-07/positive_words_self.txt", 'rb', encoding='UTF-8')
while True :
    line = pos.readline()
    line = line.replace('\n','')
    positive.append(line)
    posneg.append(line)
    
    if not line : break
pos.close()

neg = codecs.open("/Users/lwh/WORKSPACE/capstone-2022-07/negative_words_self.txt", 'rb', encoding='UTF-8')
while True :
    line = neg.readline()
    line = line.replace('\n','')
    negative.append(line)
    posneg.append(line)
    
    if not line : break
neg.close()