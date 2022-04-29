import pandas as pd
import konlpy
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from re import X
from keras.preprocessing.text import Tokenizer
import csv

train_data = pd.read_csv("./train.csv")

stopwords = ['의','가','이','은','들','는','좀','잘','걍','과','도','를','으로','자','에','와','한','하다']

okt = Okt()
X_train = []
for sentence in train_data['title']:
  temp_X =[]
  temp_X = okt.morphs(str(sentence), stem=True) #토큰화
  temp_X = [word for word in temp_X if not word in stopwords] #안쓰는 말 제거
  X_train.append(temp_X)
  
max_words = 35000
tokenizer = Tokenizer(num_words = max_words)
tokenizer.fit_on_texts(X_train)
X_train = tokenizer.texts_to_sequences(X_train)
 
  
test_data = pd.read_csv("./test1000.csv")
X_test = []
for sentence in test_data['title']:
  temp_X =[]
  temp_X = okt.morphs(str(sentence), stem=True) #토큰화
  temp_X = [word for word in temp_X if not word in stopwords] #안쓰는 말 제거
  X_test.append(temp_X)

X_test = tokenizer.texts_to_sequences(X_test)


y_train = []
for i in range(len(train_data['label'])):
  if train_data['label'].iloc[i]==1:
    y_train.append([0,0,1])
  elif train_data['label'].iloc[i]==0:
     y_train.append([0,1,0]) 
  elif train_data['label'].iloc[i]== -1:
     y_train.append([1,0,0])
y_train = np.array(y_train) 


y_test = []
for i in range(len(test_data['label'])):
  if test_data['label'].iloc[i]==1:
    y_test.append([0,0,1])
  elif test_data['label'].iloc[i]==0:
     y_test.append([0,1,0]) 
  elif test_data['label'].iloc[i]== -1:
     y_test.append([1,0,0]) 
y_test = np.array(y_test)

max_len = 20
X_train = pad_sequences(X_train, maxlen=max_len)
X_test = pad_sequences(X_test, maxlen=max_len)
model = Sequential()
model.add(Embedding(max_words, 100))
model.add(LSTM(128))
model.add(Dense(3, activation = 'softmax'))

model.compile(optimizer='adam', loss='categorical_crossentropy', metrics = ['accuracy'])
history = model.fit(X_train, y_train, epochs=10, batch_size=10, validation_split=0.1)
print("\n 테스트 정확도 : {:.2f}%".format(model.evaluate(X_test, y_test)[1]*100))

