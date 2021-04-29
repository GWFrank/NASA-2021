import json, hashlib
rainbow = dict()

for i in range(2**24):
    hashed_i = hashlib.md5(f'{i}'.encode()).hexdigest()[0:8]
    rainbow[hashed_i] = i

jdata = json.dumps(rainbow)
with open('rainbow.json', 'w') as f:
    f.write(jdata)
