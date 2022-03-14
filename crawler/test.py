import pickle

user = {'name':'Andrew K. Johnson', 'score': 199, 'location':[38.189323, 127.3495672]}

# # save data
with open('user.pkl','wb') as fw:
    pickle.dump(user, fw)

# load data
with open('user.pkl', 'rb') as f:
    data = pickle.load(f)

# show data
print(data)
# {'name':'Andrew K. Johnson', 'score': 199, 'location':[38.189323, 127.3495672]}

aa = data
print(aa)
print(aa['score'])