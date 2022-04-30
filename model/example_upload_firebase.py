import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db
# Use the application default credentials
cred = credentials.Certificate('mykey.json')
firebase_admin.initialize_app(cred, {
  'projectId': 'test-from-sj',
})

db = firestore.client()

news_temp = db.collection(u'stock').document(u'카카오').collection(u'news').document(u'temp3')
news_temp.set({
    u'date': "2022.01.19",
    u'title': "이승준, 쿼링에 성공해..",
    u'label': 1,
    u'url':"대충뉴스유알엘.com"
})
'''
stock_temp = db.collection(u'stock').document(u'카카오')
stock_temp.set({
    u'code': '0019321',
    u'name': "카카오",
    u'price': "91000",
})
'''