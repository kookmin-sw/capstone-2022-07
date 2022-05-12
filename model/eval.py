import keras
from unicodedata import name
import pandas as pd
from multiprocessing.dummy import Pool as ThreadPool
from konlpy.tag import Okt
import numpy as np
from keras.layers import Embedding, Dense, LSTM
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer
from tqdm import tqdm


model = keras.models.load_model("train.h5")
test_data = pd.read_csv("./test.csv", encoding="cp949", names=["title", "label"])
X_test = []
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

JVM_PATH = "/Library/Java/JavaVirtualMachines/zulu-15.jdk/Contents/Home/bin/java"
okt = Okt(jvmpath=JVM_PATH)
for sentence in test_data["title"]:
    temp_X = []
    temp_X = okt.morphs(str(sentence), stem=True)  # 토큰화
    temp_X = [word for word in temp_X if not word in stopwords]  # 안쓰는 말 제거
    X_test.append(temp_X)


max_words = 35000
tokenizer = Tokenizer(num_words=max_words)
tokenizer.fit_on_texts(X_test)
X_test = tokenizer.texts_to_sequences(X_test)
y_test = []
for i in tqdm(range(len(test_data["label"]))):
    if test_data["label"].iloc[i] == 1:
        y_test.append([0, 0, 1])
    elif test_data["label"].iloc[i] == 0:
        y_test.append([0, 1, 0])
    elif test_data["label"].iloc[i] == -1:
        y_test.append([1, 0, 0])

y_test = np.array(y_test)

max_len = 10000
# print("최대 길이: " + str(max_len))
X_test = pad_sequences(X_test, maxlen=max_len)
model = Sequential()
model.add(Embedding(max_words, 100))
model.add(LSTM(128))
model.add(Dense(3, activation="softmax"))

model.compile(optimizer="adam", loss="categorical_crossentropy", metrics=["accuracy"])
print("\n 테스트 정확도 : {:.2f}%".format(model.evaluate(X_test, y_test)[1] * 100))
