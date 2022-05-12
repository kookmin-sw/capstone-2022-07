# -*- coding: utf-8 -*-
# import
from unicodedata import name
import pandas as pd
from multiprocessing.dummy import Pool as ThreadPool
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer

# warning 문자 무시
import warnings

warnings.filterwarnings("ignore")

train_data = pd.read_csv("./train.csv", encoding="cp949", names=["title", "label"])
print(type(train_data["label"].iloc[0]))
stopwords = [
    "의",
    "가",
    "이",
    "은",
    "들",
    "는",
    "좀",
    "잘",
    "걍",
    "과",
    "도",
    "를",
    "으로",
    "자",
    "에",
    "와",
    "한",
    "하다",
]
del_list = [
    "오늘의",
    "뉴스",
    "급락주",
    "마감",
    "주요",
    "급등주",
    "증시일정",
    "캘린더",
    "이번주",
    "[포토]",
    "[인사]",
    "상장사",
    "주간",
    "종목",
    "총정리",
    "다음주",
    "슈퍼주총",
    "공모주",
    "돋보기",
    "週間",
    "증권주",
    "코스피",
    "코스닥",
    "KOSPI",
    "KOSDAQ",
    "승리",
    "안타",
    "홈런",
    "패배",
    "야구",
    "축구",
]

# 형태소분석
JVM_PATH = "/Library/Java/JavaVirtualMachines/zulu-15.jdk/Contents/Home/bin/java"
okt = Okt(jvmpath=JVM_PATH)
X_train = []
for sentence in train_data["title"]:
    temp_X = []
    temp_X = okt.morphs(str(sentence), stem=True)  # 토큰화
    temp_X = [word for word in temp_X if not word in stopwords]  # 안쓰는 말 제거
    X_train.append(temp_X)
max_words = 35000
# 토큰화
tokenizer = Tokenizer(num_words=max_words)
tokenizer.fit_on_texts(X_train)
X_train = tokenizer.texts_to_sequences(X_train)
# 정규화
y_train = []
for i in range(len(train_data["label"])):
    if train_data["label"].iloc[i] == "1" or train_data["label"].iloc[i] == 1:
        y_train.append([0, 0, 1])
    elif train_data["label"].iloc[i] == "0" or train_data["label"].iloc[i] == 0:
        y_train.append([0, 1, 0])
    elif train_data["label"].iloc[i] == "-1" or train_data["label"].iloc[i] == -1:
        y_train.append([1, 0, 0])
    else:
        print(train_data["label"].iloc[i])
y_train = np.array(y_train)
# 학습
max_len = 20
X_train = pad_sequences(X_train, maxlen=max_len)
model = Sequential()
model.add(Embedding(max_words, 100))
model.add(LSTM(128))
model.add(Dense(3, activation="softmax"))
model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
history = model.fit(X_train, y_train, epochs=10, batch_size=10, validation_split=0.1)
model.save("train.h5")
